//
//  PLLoginEncryptionHelper.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 18/10/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift

public final class PLLoginEncryptionHelper {}

private extension PLLoginEncryptionHelper {
    enum Constants {
        static let initialVector: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        static let SOFTWARE_TOKEN_KEY_LENGTH = 256
    }

    enum PLLoginEncryptionError: Error {
        case invalidValue
    }
}

public extension PLLoginEncryptionHelper {
    static func reEncryptUserKey(_ appId: String,
                                 pin: String?,
                                 privateKey: SecKey,
                                 encryptedUserKey: String) throws -> String {
        let decryptedAndSaltedUserKey = try Self.decryptSoftTokenUserKeyUsingTrustedDevicePrivateKey(privateKey: privateKey,
                                                                                                     encodedSoftwareTokenKey: encryptedUserKey)
        let decryptedAndSaltedUserKeyAsHexString = decryptedAndSaltedUserKey.toHexString().uppercased()
        let hexUserKey = try Self.desaltFromPublicKeyEncryption(hexString: decryptedAndSaltedUserKeyAsHexString,
                                                                privateKeyLength: privateKey.keyLenghtInBits,
                                                                symmetricKeyLength: Constants.SOFTWARE_TOKEN_KEY_LENGTH)
        let realTimeCreatedSymmetricKey = try Self.createSymmetricKeyForSoftwareTokenUserKeyUsage(appId: appId,
                                                                                                  pin: pin)
        let string = String(data: Data(hexUserKey), encoding: .utf8)
        guard let hexUserKeyBytes = string?.hexaBytes else { throw PLLoginEncryptionError.invalidValue }
        let encryptedUserKey = try Self.encryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice(softwareTokenKeyFromService: hexUserKeyBytes,
                                                                                                 symmetricKeyForSoftwareTokenUserKey: realTimeCreatedSymmetricKey)
        return encryptedUserKey.toBase64()
    }

    static func decryptRandomKey(trustedDeviceAppId: String,
                                 encodedRandomKey: String,
                                 userKey: [UInt8]?) throws -> [UInt8] {

        guard let userKey = userKey,
              let encodedRandomKey = encodedRandomKey.base64WithAddedCharacter(),
              let encodedRandomKeyData = Data(base64Encoded: encodedRandomKey) else { throw PLLoginEncryptionError.invalidValue }

        let initialVector = try Self.createInitializationVectorByTrustedDeviceAppId(appId: trustedDeviceAppId)
        let aes = try AES(key: userKey, blockMode: CBC(iv: initialVector), padding: .noPadding)
        guard let decryptedKey = try? aes.decrypt(encodedRandomKeyData.bytes) else { throw PLLoginEncryptionError.invalidValue }
        return decryptedKey
    }

    static func desaltFromPublicKeyEncryption(hexString: String,
                                              privateKeyLength: Int,
                                              symmetricKeyLength: Int) throws -> [UInt8] {
        let iterationCount = privateKeyLength / symmetricKeyLength
        let partLength = hexString.count / iterationCount

        guard let subtring = hexString.substring(partLength * (iterationCount - 1)) else { throw PLLoginEncryptionError.invalidValue }
        var hexKey = [UInt8](subtring.utf8)
        for i in (0...(iterationCount - 2)).reversed() {

            guard let subtringSalt = hexString.substring(partLength * i, partLength * (i + 1)) else { throw PLLoginEncryptionError.invalidValue }
            let salt = [UInt8](subtringSalt.utf8)

            for j in 0...hexKey.count-1 {
                var c1 = (hexKey[j] & 0xFF)
                var c2 = (salt[j] & 0xFF)

                if c1.char.isNumber {
                    c1 -= 0x30 //convert to binary digit
                }
                if (c1.char.isLetter) {
                    c1 -= 0x37; //convert to binary digit in hex
                }
                if c2.char.isNumber {
                    c2 -= 0x30 //convert to binary digit
                }
                if (c2.char.isLetter) {
                    c2 -= 0x37; //convert to binary digit in hex
                }
                var c3 = c1 ^ c2
                if (c3 < 10) {
                    c3 += 0x30 //convert from binary to ascii digit
                } else {
                    c3 += 0x37 //convert from binary hex to ascii letter
                }
                hexKey[j] = (c3 & 0xFF)
            }
        }
        return hexKey
    }

    static func createSymmetricKeyForSoftwareTokenUserKeyUsage(appId: String,
                                                               pin: String?) throws -> [UInt8] {
        let nullablePin = pin ?? ""
        let symmetricKeyInput = nullablePin + appId
        var paddedSymmetricKey = String()
        paddedSymmetricKey.append(symmetricKeyInput)
        while (paddedSymmetricKey.count < (Constants.SOFTWARE_TOKEN_KEY_LENGTH / 8)) {
            paddedSymmetricKey.append(" ");
        }
        var firstHashFromPaddedKey = paddedSymmetricKey.bytes.sha256()
        self.scrambleKeyData(symmetricKey: &firstHashFromPaddedKey)
        let encodedFirstIter = firstHashFromPaddedKey.toHexString().uppercased()
        var secondHashFromPaddedKey = encodedFirstIter.bytes.sha256()
        self.scrambleKeyData(symmetricKey: &secondHashFromPaddedKey)
        let encodedSecondIter = secondHashFromPaddedKey.toHexString().uppercased()
        let result = encodedSecondIter.bytes.sha256()

        return result
    }

    private static func scrambleKeyData(symmetricKey: inout [UInt8]) {
        for i in 1...symmetricKey.count-1 {
            symmetricKey[i] = (symmetricKey[i] ^ symmetricKey[i - 1]);
        }
    }

    // MARK: -
    static func getRandomKeyFromSoftwareToken(appId: String,
                                              pin: String?,
                                              encryptedUserKey: String,
                                              randomKey: String) throws -> String {
        let realTimeGeneratedUserKey = try Self.createSymmetricKeyForSoftwareTokenUserKeyUsage(appId: appId,
                                                                                               pin: pin)

        guard let encryptedUserKeyBytes = Data(base64Encoded: encryptedUserKey)?.bytes else { throw PLLoginEncryptionError.invalidValue }
        let userKey = try Self.decryptSoftwareTokenUserKeyStoredInTrustedDevice(encryptedUserKey: encryptedUserKeyBytes,
                                                                                symmetricKeyForSoftwareTokenUserKey: realTimeGeneratedUserKey)
        let decryptedKey = try Self.decryptRandomKey(trustedDeviceAppId: appId,
                                                     encodedRandomKey: randomKey,
                                                     userKey: userKey)
        return decryptedKey.toBase64()
    }

    // MARK: -
    static func createInitializationVectorByTrustedDeviceAppId(appId: String) throws -> [UInt8] {
        // Step-1 - Convert ASCII string to char array
        //val ch = appId.toCharArray()
        let chars = Array(appId)
        // Step-2 Iterate over char array and cast each element to Integer.
        var string = String()
        for char in chars {
            let i = Self.ascii2hex(c: char)
            // Step-3 Convert integer value to hex using toHexString() method.
            let st = String(format:"%01X", i).uppercased()
            string += st
        }
        var vector = [UInt8](repeating: 0, count: 16)
        guard let bytes = string.hexByteArray(), bytes.count < 16 else { throw PLLoginEncryptionError.invalidValue }
        vector.replaceSubrange(0...bytes.count-1, with: bytes)
        return vector
    }

    private static func ascii2hex(c: Character) -> UInt8 {
        switch c {
        case "0":
            return 0
        case "1":
            return 1
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        case "5":
            return 5
        case "6":
            return 6
        case "7":
            return 7
        case "8":
            return 8
        case "9":
            return 9
        case "A", "a":
            return 0x0A
        case "B", "b":
            return 0x0B
        case "C", "c":
            return 0x0C
        case "D", "d":
            return 0x0D
        case "E", "e":
            return 0x0E
        case "F", "f":
            return 0x0F
        default:
            let asciiValue = (c.asciiValue ?? 0x0) & 0xF
            return asciiValue
        }
    }

    // MARK:-
    static func calculateAuthorizationData(randomKey: String,
                                           challenge: String,
                                           privateKey: SecKey?) throws -> String {
        guard let randomKeyData = Data(base64Encoded: randomKey) else { throw PLLoginEncryptionError.invalidValue }
        let hashedAndSaltedRandomKey = Self.calculateHash(randomKey: randomKeyData.bytes)
        var bytesChallenge = challenge.bytes
        for i in bytesChallenge.indices {
            bytesChallenge[i] = bytesChallenge[i] - 0x30
            bytesChallenge[i] = bytesChallenge[i] & 0xFF
        }
        guard let encryptedChallenge = privateKey?.sign(Data(bytesChallenge), algorithm: .rsaSignatureRaw) else { throw PLLoginEncryptionError.invalidValue }
        var dataToEncode = [UInt8](repeating: 0, count: (hashedAndSaltedRandomKey.count + encryptedChallenge.count))
        dataToEncode = hashedAndSaltedRandomKey + encryptedChallenge
        return dataToEncode.toBase64()
    }

    static func calculateHash(randomKey: [UInt8]) -> [UInt8] {
        var saltedRandomKey: [UInt8] =  [UInt8](repeating: 0, count: randomKey.count)
        let len = randomKey.count / 4
        var i = 0
        while (i < len) {
            saltedRandomKey[i] =
                (randomKey[i] ^ randomKey[len + i] ^ randomKey[2 * len + i] ^ randomKey[3 * len + i] & 0xFF)
            i += 1
        }
        return saltedRandomKey.sha256()
    }

    static func encryptSoftwareTokenUserKeyForStoringItIntoTrustedDevice(softwareTokenKeyFromService: [UInt8],
                                                                         symmetricKeyForSoftwareTokenUserKey: [UInt8]) throws -> [UInt8] {
        let aes = try AES(key: symmetricKeyForSoftwareTokenUserKey, blockMode: CBC(iv: Constants.initialVector), padding: .noPadding)
        guard let encryptedParametersBytes = try? aes.encrypt(softwareTokenKeyFromService) else { throw PLLoginEncryptionError.invalidValue }
        return encryptedParametersBytes
    }

    static func decryptSoftwareTokenUserKeyStoredInTrustedDevice(encryptedUserKey: [UInt8],
                                                                 symmetricKeyForSoftwareTokenUserKey: [UInt8]) throws -> [UInt8] {
        let aes = try AES(key: symmetricKeyForSoftwareTokenUserKey, blockMode: CBC(iv: Constants.initialVector), padding: .noPadding)
        guard let decryptedUserKey = try? aes.decrypt(encryptedUserKey) else { throw PLLoginEncryptionError.invalidValue }
        return decryptedUserKey
    }

    static func decryptSoftTokenUserKeyUsingTrustedDevicePrivateKey(privateKey: SecKey,
                                                                    encodedSoftwareTokenKey: String ) throws -> [UInt8] {
        guard let encodedSoftwareTokenKeyBytes = Data(base64Encoded: encodedSoftwareTokenKey)?.bytes else { throw PLLoginEncryptionError.invalidValue }
        guard let userKey = privateKey.decrypt(bytes: encodedSoftwareTokenKeyBytes, algorithm: .rsaEncryptionRaw) else { throw PLLoginEncryptionError.invalidValue }
        return userKey.bytes
    }
}

private extension SecKey {
    var keyLenghtInBits: Int {
        self.blockSize * 8
    }

    func sign(_ data: Data, algorithm: SecKeyAlgorithm) -> Data? {
        guard SecKeyIsAlgorithmSupported(self, .sign, algorithm) else { return nil }
        let signedData = SecKeyCreateSignature(self, algorithm, data as CFData, nil) as Data?
        return signedData
    }

    func decrypt(bytes: [UInt8], algorithm: SecKeyAlgorithm) -> Data? {
        guard SecKeyIsAlgorithmSupported(self, .decrypt, algorithm) else { return nil }
        var error: Unmanaged<CFError>?
        guard let data = SecKeyCreateDecryptedData(self, algorithm, Data(bytes) as CFData, &error) as Data? else { return nil }
        return data
    }
}

// Need to be tested more deeply
// In Android they have fun ByteArray.encodeBase64(): ByteArray (third party much more complex)
// https://stackoverflow.com/questions/31859185/how-to-convert-a-base64string-to-string-in-swift
private extension String {
    func base64WithAddedCharacter() -> String? {
        var st = self;
        let count = self.count % 4
        if (count != 0){
            st += String(repeating: "=", count: 4-count )
        }
        return st
    }
}

private extension UInt8 {
    var char: Character {
        return Character(UnicodeScalar(self))
    }
}
