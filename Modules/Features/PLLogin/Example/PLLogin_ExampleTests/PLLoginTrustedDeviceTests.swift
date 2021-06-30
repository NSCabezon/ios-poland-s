//
//  PLLoginTrustedDeviceTests.swift
//  PLLogin_ExampleTests
//
//  Created by Marcos Álvarez Mesa on 8/6/21.
//

import XCTest
@testable import PLLogin
import CryptoSwift

class PLLoginTrustedDeviceTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    /**
     Tranport key (TKey)Transport key is the random string with the length of 128 bits created on OneApp. (16 bytes * 8 bit/byte = 128 bits)
     It is encrypted using AES128 method with the key (PassKey) prepared from password that was typed while logging in.
     An initial vector is set to zeros.
     PassKey is created from password by multiplying password’s characters till achieving 128-bit-length string.
     For example:Genereted TKey consists of characters (presented in hexadecimal form):TKey=0xAE125FBC8D227E046E 56BB12C45F21B2.
     Assume that the password is “3ftg48x!!z2” and the password mask 010001111010 where 0 means that the character is not entered.
     It means that during logging in a string “348x!z” was typed.
     After multiplying this string to expected length the final string of PassKey=“348x!z348x!z348x” is obtained.
     In the hexadecimal form PassKey is 0x33343878217A33343878217A33343878.
     Now TKey is encrypted by PassKey with initial vector filled with zeros and the result is 0x351623486117451CE1C8B360C83E1A07
     */
    func testTransportKeyEncryption() {

        enum Constants {
            // TKey is randomly generated (In this case for the unit test we use this one)
            static let TKey: Array<UInt8> = [0xAE, 0x12, 0x5F, 0xBC, 0x8D, 0x22, 0x7E, 0x04, 0x6E, 0x56, 0xBB, 0x12, 0xC4, 0x5F, 0x21, 0xB2]
            // The initial vector to encrypt needs to be set to 0
            static let initialVector: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

            enum ExpectedResult {
                // PassKey=“348x!z348x!z348x” -> Hexadecimal = 0x33 34 38 78 21 7A 33 34 38 78 21 7A 33 34 38 78.
                static let passKeyBytes: Array<UInt8> = [0x33, 0x34, 0x38, 0x78, 0x21, 0x7A, 0x33, 0x34, 0x38, 0x78, 0x21, 0x7A, 0x33, 0x34, 0x38, 0x78]
                // Tkey encripted with AES128 with the PassKey must be = 0x35 16 23 48 61 17 45 1C E1 C8 B3 60 C8 3E 1A 07
                static let encryptedTransportKey: Array<UInt8> = [0x35, 0x16, 0x23, 0x48, 0x61, 0x17, 0x45, 0x1C, 0xE1, 0xC8, 0xB3, 0x60, 0xC8, 0x3E, 0x1A, 0x07]
                // Tkey encrypted passed to base 64
                static let encryptedTransportKeyBase64 = "NRYjSGEXRRzhyLNgyD4aBw=="
            }
        }

        // User's complete password is “3ftg48x!!z2”
        // and the password mask 010001111010 where 0 means that the character is not entered.
        // It means that during logging in a string “348x!z” was typed.
        // We need to repeat it to have a 16 characters lenght string
        // PassKey=“348x!z348x!z348x” -> Hexadencimal = 0x33 34 38 78 21 7A 33 34 38 78 21 7A 33 34 38 78
        let typedPasskey = "348x!z"
        // Lenght 16 password
        let passKeyLength16 = PLLoginTrustedDeviceHelpers.length16Password(typedPasskey)
        // Length 16 password bytes
        let passKeyLength16Bytes = passKeyLength16?.bytes
        // Test passKeyLength16Bytes
        XCTAssertEqual(passKeyLength16Bytes, Constants.ExpectedResult.passKeyBytes)

        // Test Encryption
        // Tkey encrypted with AES128 with the PassKey and initial vector to 0
        let aes = try! AES(key: passKeyLength16Bytes!, blockMode: CBC(iv: Constants.initialVector), padding: .noPadding)
        let encryptedTransportKey = try! aes.encrypt(Constants.TKey)
        XCTAssertEqual(encryptedTransportKey, Constants.ExpectedResult.encryptedTransportKey, "Encryption failed")

        // Test Decryption (This is not necessary but it could be useful for other processes)
        let decrypted = try! aes.decrypt(encryptedTransportKey)
        XCTAssertEqual(decrypted, Constants.TKey, "Decryption failed")

        //Test encryptedTransportKeyBase64
        let encryptedTransportKeyBase64 = encryptedTransportKey.toBase64()
        XCTAssertEqual(encryptedTransportKeyBase64, Constants.ExpectedResult.encryptedTransportKeyBase64)
    }

    /**
     Test parameters encrytion
     Parameters string obtained by getting the different values needs to be encrypted with AES 128 using the TKey (secure random)
     */
    func testParametersEncryption() {

        enum Constants {
            static let parametersString = "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>>"
            static let initialVector: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
            static let TKey: Array<UInt8> = [0xAE, 0x12, 0x5F, 0xBC, 0x8D, 0x22, 0x7E, 0x04, 0x6E, 0x56, 0xBB, 0x12, 0xC4, 0x5F, 0x21, 0xB2]

            enum ExpectedResult {

                static let encryptedParametersStringHexadecimal = "C77109347B4BD1090C6D067F2C9FFA570F16C1D805A3802FDBB3F4C0A35223FE9B003A02CD0FB19E723BDD53163B70646470490F474C2735FDDEA9C58E2C49929295AB87D66914E853E00A108AB5C1BF9D87ACA51A1C5D37F1D1856E9D3A224D35639105DC13EDBB26CB6FFDFCDB89118B00E2E0A8A35C5ADB1AF16B6A3DDD3FBF414BC8D6F91DC37BCF8CF1D00B5019"

                static let parametersStringHexadecimalBase64 = "x3EJNHtL0QkMbQZ/LJ/6Vw8WwdgFo4Av27P0wKNSI/6bADoCzQ+xnnI73VMWO3BkZHBJD0dMJzX93qnFjixJkpKVq4fWaRToU+AKEIq1wb+dh6ylGhxdN/HRhW6dOiJNNWORBdwT7bsmy2/9/NuJEYsA4uCoo1xa2xrxa2o93T+/QUvI1vkdw3vPjPHQC1AZ"
            }
        }

        let parametersBytes = Constants.parametersString.bytes

        // Tkey encrypted with AES128 with the TKey and initial vector to 0 (For padding is used .pkcs5 as .nopadding can´t be used due to the string length which will be different to 16 bytes length)
        let aes = try! AES(key: Constants.TKey, blockMode: CBC(iv: Constants.initialVector), padding: .pkcs5)
        let encryptedParametersBytes = try! aes.encrypt(parametersBytes)

        let encryptedParametersHexString = encryptedParametersBytes.toHexString()

        // Test encripted hex string
        XCTAssertEqual(encryptedParametersHexString.uppercased(), Constants.ExpectedResult.encryptedParametersStringHexadecimal)

        // Test encripted hex string in Base 64
        XCTAssertEqual(encryptedParametersBytes.toBase64(), Constants.ExpectedResult.parametersStringHexadecimalBase64)
    }
}


//PRAGMA MARK: - Test to make all the reverse process (process it is doing the backend) to get decrypted parameters
extension PLLoginTrustedDeviceTests {

    // Knowing password, encrypted TKEy base 64 and encrypted parameters base 64 -> Decrypt TKey to decrypt parameters
    func testReverseCompleteProcess() {

        enum Constants {
            static let initialVector: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

            enum Input {
                static let password = "348x!z"
                static let encryptedTransportKeyBase64 = "NRYjSGEXRRzhyLNgyD4aBw=="
                static let parametersStringHexadecimalBase64 = "x3EJNHtL0QkMbQZ/LJ/6Vw8WwdgFo4Av27P0wKNSI/6bADoCzQ+xnnI73VMWO3BkZHBJD0dMJzX93qnFjixJkpKVq4fWaRToU+AKEIq1wb+dh6ylGhxdN/HRhW6dOiJNNWORBdwT7bsmy2/9/NuJEYsA4uCoo1xa2xrxa2o93T+/QUvI1vkdw3vPjPHQC1AZ"
            }

            enum ExpectedResult {
                static let TKey: Array<UInt8> = [0xAE, 0x12, 0x5F, 0xBC, 0x8D, 0x22, 0x7E, 0x04, 0x6E, 0x56, 0xBB, 0x12, 0xC4, 0x5F, 0x21, 0xB2]
                static let parametersString = "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><samsung><model><SM-A600FN>>"
            }
        }


        // TKEY decryption with password
        let passKeyLength16 = PLLoginTrustedDeviceHelpers.length16Password(Constants.Input.password)
        let passKeyLength16Bytes = passKeyLength16?.bytes

        let encryptedTKeyData = Data(base64Encoded: Constants.Input.encryptedTransportKeyBase64)
        let encryptedTKeyBytes = (encryptedTKeyData?.bytes)!
        //let TKeyBytes = (encryptedTKey64Data!.toHexString().hexaBytes)
        let aes2 = try! AES(key: passKeyLength16Bytes!, blockMode: CBC(iv: Constants.initialVector), padding: .noPadding)
        let decryptedTransportKey = try! aes2.decrypt(encryptedTKeyBytes)
        // Test that decrypted TKey is what we are expecting
        XCTAssertEqual(decryptedTransportKey, Constants.ExpectedResult.TKey)


        // PARAMETERS decryption
        let encryptedParametersData = Data(base64Encoded: Constants.Input.parametersStringHexadecimalBase64)
        let encryptedParametersBytes = (encryptedParametersData?.bytes)!
        let aes = try! AES(key: decryptedTransportKey, blockMode: CBC(iv: Constants.initialVector), padding: .pkcs5)
        let decryptedParametersBytes = try! aes.decrypt(encryptedParametersBytes)
        let parametersString = String(bytes: decryptedParametersBytes, encoding: .utf8)

        XCTAssertEqual(parametersString, Constants.ExpectedResult.parametersString)

        //NOTE: The following lines are not needed but I´m testing different conversions to get the same result
        // Bytes -> Hex String
        let decryptedHexString = decryptedParametersBytes.toHexString()
        // Hex String -> Bytes
        let decryptedBytes = decryptedHexString.hexa
        // Bytes -> string
        let parametersStringToHexToBytes = String(bytes: decryptedBytes, encoding: .utf8)

        XCTAssertEqual(parametersStringToHexToBytes, Constants.ExpectedResult.parametersString)
    }

    func testHexadecimalString() {

        let expectedBytes: Array<UInt8> = [0x33, 0x34, 0x38, 0x78, 0x21, 0x7A, 0x33, 0x34, 0x38, 0x78, 0x21, 0x7A, 0x33, 0x34, 0x38, 0x78]
        XCTAssertEqual("348x!z348x!z348x".bytes, expectedBytes)
    }

}

private extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
