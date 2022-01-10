//
//  TaxTransferFormValidator.swift
//  TaxTransfer
//
//  Created by 185167 on 05/01/2022.
//

protocol TaxTransferFormValidating {
    func validateDataWithoutAmountLimits(_ data: TaxTransferFormFieldsData) -> TaxTransferFormValidity
}

final class TaxTransferFormValidator: TaxTransferFormValidating {
    enum Error: Swift.Error {
        case illegalCharacters
    }
    
    func validateDataWithoutAmountLimits(_ data: TaxTransferFormFieldsData) -> TaxTransferFormValidity {
        if data.obligationIdentifier.isEmpty {
            return invalidStateWithEmptyMessages
        }
        
        do {
            let isIdentifierIllegal = try checkForIllegalCharacters(in: data.obligationIdentifier)
            
            switch (isIdentifierIllegal, data.amount.isEmpty) {
            case (true, _):
                throw Error.illegalCharacters
            case (false, true):
                return invalidStateWithEmptyMessages
            case (false, false):
                return .valid
            }
        } catch {
            return invalidStateWithIllegalIdentifier
        }
    }
}

private extension TaxTransferFormValidator {
    private func checkForIllegalCharacters(in text: String) throws -> Bool {
        let regexText = "^[0-9A-Za-ząęćółńśżźĄĘĆÓŁŃŚŻŹ\\-\\.\\:\\;, ]+$"
        let regex = try NSRegularExpression(pattern: regexText)
        let range = NSRange(location: 0, length: text.utf16.count)
        return regex.firstMatch(in: text, options: [], range: range) == nil
    }
    
    private var invalidStateWithEmptyMessages: TaxTransferFormValidity {
        let messages = TaxTransferFormValidity.InvalidFormMessages(
            amountMessage: nil,
            obligationIdentifierMessage: nil
        )
        return .invalid(messages)
    }
    
    private var invalidStateWithIllegalIdentifier: TaxTransferFormValidity {
        let messages = TaxTransferFormValidity.InvalidFormMessages(
            amountMessage: nil,
            obligationIdentifierMessage: "#Niepoprawna identyfikacja zobowiązania"
        )
        return .invalid(messages)
    }
}
