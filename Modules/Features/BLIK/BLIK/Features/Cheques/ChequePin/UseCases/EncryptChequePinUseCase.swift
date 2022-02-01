import CoreFoundationLib
import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol EncryptChequePinUseCaseProtocol: UseCase<EncryptChequePinUseCaseInput, String, StringErrorOutput> {}

final class EncryptChequePinUseCase: UseCase<EncryptChequePinUseCaseInput, String, StringErrorOutput> {
    enum Error: Swift.Error {
        case incorrectKeyData
        case messageTooLongForRsa
        case cannotEncryptData
        case cannotCreateSecKey
    }
    
    private let managersProvider: PLManagersProviderProtocol
    private let modelMapper: PubKeyModelMapping
    
    init(
        managersProvider: PLManagersProviderProtocol,
        modelMapper: PubKeyModelMapping = PubKeyModelMapper()
    ) {
        self.managersProvider = managersProvider
        self.modelMapper = modelMapper
    }
    
    override func executeUseCase(requestValues: EncryptChequePinUseCaseInput) throws -> UseCaseResponse<String, StringErrorOutput> {
        let result = try managersProvider.getBLIKManager().getPinPublicKey()
        switch result {
        case .success(let pubKeyDto):
            let pubKey = modelMapper.map(dto: pubKeyDto)
            
            let secKey = try createSecKey(for: pubKey)
            let encryptedPin = try encrypt(
                text: requestValues.chequePin.pin,
                using: secKey
            )
            return .ok(encryptedPin)
            
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
    
    private func createSecKey(for pubKey: PubKey) throws -> SecKey {
        var modulus = try mapToUInt8Array(pubKey.modulus)
        var exponent = try mapToUInt8Array(pubKey.exponent)
        modulus.insert(0x00, at: 0)
        exponent.insert(0x00, at: 0)
        let keyData = try mapToAsn1(modulus: modulus, exponent: exponent)
        let secKey = try createSecKey(asn1KeyData: keyData, modulus: modulus)
        return secKey
    }

    private func mapToAsn1(modulus: [UInt8], exponent: [UInt8]) throws -> Data {
        var modulusEncoded: [UInt8] = []
        modulusEncoded.append(0x02)
        modulusEncoded.append(contentsOf: lengthField(of: modulus))
        modulusEncoded.append(contentsOf: modulus)

        var exponentEncoded: [UInt8] = []
        exponentEncoded.append(0x02)
        exponentEncoded.append(contentsOf: lengthField(of: exponent))
        exponentEncoded.append(contentsOf: exponent)

        var sequenceEncoded: [UInt8] = []
        sequenceEncoded.append(0x30)
        sequenceEncoded.append(contentsOf: lengthField(of: (modulusEncoded + exponentEncoded)))
        sequenceEncoded.append(contentsOf: (modulusEncoded + exponentEncoded))

        let keyData = Data(sequenceEncoded)
        return keyData
    }

    private func mapToUInt8Array(_ string: String) throws -> [UInt8] {
        if string.count & 1 == 1 {
            throw Error.incorrectKeyData
        }
        return try stride(from: 0, to: string.count, by: 2).map { index in
            let startIndex = string.index(string.startIndex, offsetBy: index)
            let endIndex = string.index(startIndex, offsetBy: 2)
            let stringChunk = String(string[startIndex..<endIndex])
            guard let num = UInt8(stringChunk, radix: 16) else {
                throw Error.incorrectKeyData
            }
            return num
        }
    }

    private func lengthField(of valueField: [UInt8]) -> [UInt8] {
        var count = valueField.count

        if count < 128 {
            return [ UInt8(count) ]
        }

        // The number of bytes needed to encode count.
        let lengthBytesCount = Int((log2(Double(count)) / 8) + 1)

        // The first byte in the length field encoding the number of remaining bytes.
        let firstLengthFieldByte = UInt8(128 + lengthBytesCount)

        var lengthField: [UInt8] = []
        for _ in 0..<lengthBytesCount {
            // Take the last 8 bits of count.
            let lengthByte = UInt8(count & 0xff)
            // Add them to the length field.
            lengthField.insert(lengthByte, at: 0)
            // Delete the last 8 bits of count.
            count = count >> 8
        }

        // Include the first byte.
        lengthField.insert(firstLengthFieldByte, at: 0)

        return lengthField
    }

    private func createSecKey(asn1KeyData keyData: Data, modulus: [UInt8]) throws -> SecKey {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: modulus.count * 8,
            kSecAttrIsPermanent as String: false
        ]
        var error: Unmanaged<CFError>?
        guard let keyReference = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
            if let error = error?.takeRetainedValue() {
                throw error as Swift.Error
            }
            throw Error.cannotCreateSecKey
        }
        return keyReference
    }

    private func encrypt(text: String, using secKey: SecKey) throws -> String {
        let blockSize = SecKeyGetBlockSize(secKey)
        var encryptedBytes = [UInt8](repeating: 0, count: blockSize)
        var encryptedBytesSize = blockSize

        let status = SecKeyEncrypt(secKey, SecPadding.PKCS1, text, text.count, &encryptedBytes, &encryptedBytesSize)
        guard status == 0  else {
            throw Error.cannotEncryptData
        }
        let encryptedString = encryptedBytes.map { String(format: "%02X", $0) }.joined()
        return encryptedString
    }
}

extension EncryptChequePinUseCase: EncryptChequePinUseCaseProtocol {}

struct EncryptChequePinUseCaseInput {
    let chequePin: ChequePin
}
