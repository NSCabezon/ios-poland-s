//
//  TaxAccountTypeRecognizer.swift
//  TaxTransfer
//
//  Created by 185167 on 14/02/2022.
//

protocol TaxAccountTypeRecognizing {
    func recognizeType(of accountNumber: String) throws -> TaxAccountType
}

final class TaxAccountTypeRecognizer: TaxAccountTypeRecognizing {
    private let identifierValidator: TaxIdentifierValidating
    
    init(identifierValidator: TaxIdentifierValidating) {
        self.identifierValidator = identifierValidator
    }
    
    func recognizeType(of accountNumber: String) throws -> TaxAccountType {
        try verifyLength(of: accountNumber)
        try verifyCharacters(of: accountNumber)
        let isAccountAnIrpType = checkIfAccountIsIrpType(accountNumber)
        
        if isAccountAnIrpType {
            return .IRP
        } else {
            return .US
        }
    }
    
    private func verifyLength(of accountNumber: String) throws {
        let requiredAccountLength = 26
        let isAccountLengthValid = (accountNumber.count == requiredAccountLength)
        guard isAccountLengthValid else {
            throw Error.invalidAccountLength
        }
    }
    
    private func verifyCharacters(of accountNumber: String) throws {
        let isAccountANumber = CharacterSet.numbers.isSuperset(of: CharacterSet(charactersIn: accountNumber))
        guard isAccountANumber else {
            throw Error.illegalCharacters
        }
    }
    
    // IRP Account Type format:
    // CC10100071222YXXXXXXXXXXXX (26 digits long)
    //
    // CC -> Control Number (2 digits long)
    // 10100071222 -> constant number in every IRP account type
    // Y -> IRP Identifier Type (1 digit long, only possible values are 1 (PESEL), 2 (NIP) or 3)
    // XXXXXXXXXXXX -> IRP identifier (12 digits long)
    //
    private func checkIfAccountIsIrpType(_ accountNumber: String) -> Bool {
        let potentialIrpMaskConstant = String(
            accountNumber
                .dropFirst(controlNumberLength)
                .dropLast(irpIdentifierLength)
                .dropLast(irpIdentifierTypeLength)
        )
        let irpIdentifierType = String(
            accountNumber
                .dropFirst(controlNumberLength)
                .dropFirst(irpMaskConstant.count)
                .dropLast(irpIdentifierLength)
        )
        
        let isIrpIdentifierTypeLegal = legalIrpIdentifierTypeCharacterSet.isSuperset(
            of: CharacterSet(charactersIn: irpIdentifierType)
        )
        do {
            let irpIdentifier = String(
                accountNumber.dropFirst(controlNumberLength + irpMaskConstant.count + irpIdentifierTypeLength)
            )
            if irpIdentifierType == IrpIdentifierType.pesel.rawValue {
                try validateIdentifier(irpIdentifier, ofType: .pesel)
            }
            if irpIdentifierType == IrpIdentifierType.nip.rawValue {
                try validateIdentifier(irpIdentifier, ofType: .nip)
            }
        } catch {
            return false
        }
        return (potentialIrpMaskConstant == irpMaskConstant) && isIrpIdentifierTypeLegal
    }
    
    private func validateIdentifier(_ identifier: String, ofType type: IrpIdentifierType) throws {
        try verifyIdentifierSuffix(in: identifier, ofType: type)
        let trimmedIdentifier = String(identifier.dropLast(identifier.count - type.identifierLength))
        guard identifierValidator.validate(type: type.taxIdentifierType, value: trimmedIdentifier) == .valid else {
            throw Error.invalidIdentifier
        }
    }
    
    private func verifyIdentifierSuffix(in identifier: String, ofType type: IrpIdentifierType) throws {
        let suffixLength = identifier.count - type.identifierLength
        let expectedSuffix = String(repeating: "0", count: suffixLength)
        guard identifier.substring(ofLast: suffixLength) == expectedSuffix else {
            throw Error.invalidIdentifier
        }
    }
}

extension TaxAccountTypeRecognizer {
    enum Error: Swift.Error {
        case invalidAccountLength
        case illegalCharacters
        case invalidIdentifier
    }
    
    private var irpMaskConstant: String { "10100071222" }
    private var controlNumberLength: Int { 2 }
    private var irpIdentifierTypeLength: Int { 1 }
    private var irpIdentifierLength: Int { 12 }
    private var legalIrpIdentifierTypeCharacterSet: CharacterSet {
        CharacterSet(charactersIn: "123")
    }
    
    private enum IrpIdentifierType: String {
        case pesel = "1"
        case nip = "2"
        case other = "3"
        
        var identifierLength: Int {
            switch self {
            case .pesel:
                return 11
            case .nip:
                return 10
            case .other:
                return 12
            }
        }
        
        var taxIdentifierType: TaxIdentifierType {
            switch self {
            case .pesel:
                return .PESEL
            case .nip:
                return .NIP
            case .other:
                return .other
            }
        }
    }
}
