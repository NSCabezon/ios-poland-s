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
    enum Error: Swift.Error {
        case invalidAccountLength
        case illegalCharacters
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
        let irpMaskConstant = "10100071222"
        let controlNumberLength = 2
        let irpIdentifierTypeLength = 1
        let irpIdentifierLength = 12
        let legalIrpIdentifierTypeCharacterSet = CharacterSet(charactersIn: "123")
        
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
        return (potentialIrpMaskConstant == irpMaskConstant) && isIrpIdentifierTypeLegal
    }
}
