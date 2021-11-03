//
//  PLPinParametersEncryptionUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 30/6/21.
//

import Commons
import PLCommons
import DomainCommon
import CryptoSwift
import Security
import CommonCrypto
import os

final class PLSoftwareTokenParametersEncryptionUseCase: UseCase<PLSoftwareTokenParametersEncryptionUseCaseInput, PLSoftwareTokenParametersEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>, PLLoginUseCaseErrorHandlerProtocol {
    var dependenciesResolver: DependenciesResolver

    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    public override func executeUseCase(requestValues: PLSoftwareTokenParametersEncryptionUseCaseInput) throws -> UseCaseResponse<PLSoftwareTokenParametersEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {

        do {
            let encryptedParameters = try self.encryptParameters(requestValues.parameters,
                                                                 with: requestValues.key)
            return .ok(PLSoftwareTokenParametersEncryptionUseCaseOutput(encryptedParameters: encryptedParameters))
        } catch {
            return .error(PLUseCaseErrorOutput(errorDescription: error.localizedDescription))
        }
    }
}

private extension PLSoftwareTokenParametersEncryptionUseCase {

    // parameters: string with parameters to encrypt (i.e. "<2021-04-18 22:01:11.238><<AppId><1234567890abcdef12345678><deviceId><8b3339657561287d><manufacturer><Apple><model><iPhone 12>>")
    // key: key that will be use to encrypt parameters.
    func encryptParameters(_ parameters: String, with key: SecKey) throws -> String {

        // Transform parameters into what we need before encrypting
        guard let bytesToEncrypt = Self.separateAndParciallyHashParameters(parameters: parameters) else {
            throw PLUseCaseErrorOutput<LoginErrorType>(errorDescription: "Error separating to encrypt")
        }

        guard let signedData = key.customSignWithoutHash(data: bytesToEncrypt)
        else { throw PLUseCaseErrorOutput<LoginErrorType>(errorDescription: "Error encrypting parameters") }

        os_log("✅ [TRUSTED DEVICE][Software Token] Parameters to encrypt: %@", log: .default, type: .info, parameters)
        os_log("✅ [TRUSTED DEVICE][Software Token] Parameters partially hashed: %@", log: .default, type: .info, Data(bytesToEncrypt).base64EncodedString())
        os_log("✅ [TRUSTED DEVICE][Software Token] Parameters signed with private key: %@", log: .default, type: .info, Data(signedData).base64EncodedString())

        return Data(signedData).base64EncodedString()
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
    // and hash postfix with SHA256
    // Retuns concatenation of both arrays of bytes
    static func separateAndParciallyHashParameters(parameters: String) -> [UInt8]? {
        let nsString = parameters as NSString
        let range = nsString.range(of: "<deviceId>")
        guard range.length != 0 else { return nil }
        let prefix = parameters.substring(0, range.location)
        let postfix = parameters.substring(range.location, parameters.count)
        var concatenatedBytes: [UInt8] = Array()
        guard let prefixBytes = prefix?.bytes,
              let hashedPostfixBytes = postfix?.bytes.sha256() else {
            return nil
        }
        concatenatedBytes.append(contentsOf: prefixBytes)
        concatenatedBytes.append(contentsOf: hashedPostfixBytes)
        return concatenatedBytes
    }
}

extension SecKey {
   public func customSignWithoutHash(data:[UInt8]) -> [UInt8]? {
        var signature = [UInt8](repeating: 0, count: 1024)
        var signatureLength = 1024
        let status = SecKeyRawSign(self, .PKCS1, data, data.count, &signature, &signatureLength)
        guard status == errSecSuccess else {
            return nil
        }
        let realSignature = signature[0 ..< signatureLength]
        return Array(realSignature)
    }
}
