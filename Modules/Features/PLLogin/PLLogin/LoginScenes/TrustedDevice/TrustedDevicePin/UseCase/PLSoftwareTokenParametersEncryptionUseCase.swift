//
//  PLPinParametersEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 30/6/21.
//

import Commons
import DomainCommon
import CryptoSwift
import Security

final class PLSoftwareTokenParametersEncryptionUseCase: UseCase<PLSoftwareTokenParametersEncryptionUseCaseInput, PLSoftwareTokenParametersEncryptionUseCaseOutput, PLSoftwareTokenUseCaseErrorOutput> {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLSoftwareTokenParametersEncryptionUseCaseInput) throws -> UseCaseResponse<PLSoftwareTokenParametersEncryptionUseCaseOutput, PLSoftwareTokenUseCaseErrorOutput> {

        do {
            let encryptedParameters = try self.encryptParameters(requestValues.parameters,
                                                                 with: requestValues.key)
            return UseCaseResponse.ok(PLSoftwareTokenParametersEncryptionUseCaseOutput(encryptedParameters: encryptedParameters))
        } catch {
            return UseCaseResponse.error(PLSoftwareTokenUseCaseErrorOutput(error.localizedDescription))
        }
    }
}

private extension PLSoftwareTokenParametersEncryptionUseCase {

    enum Constants {
        static let initialVector: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    }

    // parameters: string with parameters to encrypt (i.e. "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><Apple><model><iPhone 12>>")
    // key: key that will be use to encrypt parameters.
    func encryptParameters(_ parameters: String, with key: SecKey) throws -> String {

        // Transform parameters into what we need before encrypting
        guard let bytesToEncrypt = Self.separateAndEncryptParameters(parameters: parameters) else {
            throw PLSoftwareTokenUseCaseErrorOutput.init("Error separating to encrypt")
        }

        //let anotherEncryption = self.encrypt2(bytes: bytesToEncrypt, key: key)

        guard let encryption = self.encrypt(bytes: bytesToEncrypt, key: key)
        else {
            throw PLSoftwareTokenUseCaseErrorOutput.init("Error encrypting parameters")
        }

        return encryption
    }

    func encrypt(bytes: [UInt8], key: SecKey) -> String? {
        var error: Unmanaged<CFError>?
        guard let data = SecKeyCreateEncryptedData(key, .rsaEncryptionPKCS1, Data(bytes) as CFData, &error) as Data? else { return nil }
        return data.base64EncodedString()
    }

    /// Encrypt a plain text using a public key
    func encrypt2(bytes: [UInt8], key: SecKey) -> String? {
        var keySize   = SecKeyGetBlockSize(key)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)

        guard SecKeyEncrypt(key, SecPadding.PKCS1, bytes, bytes.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        let hexEncondedString = Data(bytes: keyBuffer, count: keySize).base64EncodedString()

        return hexEncondedString
    }
}

// MARK: I/O types definition
struct PLSoftwareTokenParametersEncryptionUseCaseInput {
    let parameters: String
    let key: SecKey
}

struct PLSoftwareTokenParametersEncryptionUseCaseOutput {
    let encryptedParameters: String
}


internal extension PLSoftwareTokenParametersEncryptionUseCase {

    // Having this string <2021-04-18 22:01:11.238><AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>
    // we need to separate in two strings:
    // prefix = <2021-04-18 22:01:11.238><AppId><1234567890abcdef12345678>
    // postfix = <deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>
    // and encrypt postfix with SHA256
    // Retuns concatenation of both arrays of bytes
    static func separateAndEncryptParameters(parameters: String) -> [UInt8]? {
        let nsString = parameters as NSString
        let range = nsString.range(of: "<deviceId>")
        guard range.length != 0 else { return nil }
        let prefix = parameters.substring(0, range.location)
        let prefixBytes = prefix?.bytes
        let postfix = parameters.substring(range.location, parameters.count)
        let postfixBytes = postfix?.bytes
        let encryptedPostfixBytes = postfixBytes?.sha256()
        var concatenatedBytes: [UInt8] = Array()
        concatenatedBytes.append(contentsOf: prefixBytes!)
        concatenatedBytes.append(contentsOf: encryptedPostfixBytes!)
        return concatenatedBytes
    }
}
