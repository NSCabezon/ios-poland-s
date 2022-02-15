//
//  AccountTransactionDetailDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary
import PLCommons
import CoreFoundationLib

public final class AccountTransactionDetailDTOAdapter {
    public static func adaptPLAccountTransactionToAccountTransactionDetail(_ accountTransaction: SANLegacyLibrary.AccountTransactionDTO) -> SANLegacyLibrary.AccountTransactionDetailDTO {
        var accountTransactionDetailDTO = AccountTransactionDetailDTO()
        var literals = [LiteralDTO]()
        if let recipientDataConcept = accountTransaction.recipientData, !recipientDataConcept.isBlank {
            literals.append(LiteralDTO(concept: recipientDataConcept, literal: localized("transaction_label_recipientData")))
        }
        if let recipientAccountNumberConcept = accountTransaction.recipientAccountNumber, !recipientAccountNumberConcept.isBlank {
            literals.append(LiteralDTO(concept: IBANFormatter.format(iban: recipientAccountNumberConcept), literal: localized("transaction_label_recipientAccount")))
        }
        if let state = accountTransaction.status, let stateValue = self.getValueForState(state) {
            literals.append(LiteralDTO(concept: stateValue, literal: localized("transaction_label_statusDetail")))
        }
        if let senderDataConcept = accountTransaction.senderData, !senderDataConcept.isBlank {
            literals.append(LiteralDTO(concept: senderDataConcept, literal: localized("transaction_label_senderData")))
        }
        if let senderAccountNumberConcept = accountTransaction.senderAccountNumber, !senderAccountNumberConcept.isBlank {
            literals.append(LiteralDTO(concept: IBANFormatter.format(iban: senderAccountNumberConcept), literal: localized("transaction_label_senderAccountNumber")))
        }
        accountTransactionDetailDTO.literalDTOs = literals
        return accountTransactionDetailDTO
    }

    private static func getValueForState(_ state: String) -> String? {
        let accountTransactionState = AccountTransactionState(rawValue: state.uppercased())
        switch accountTransactionState {
        case .cardAuthorisation:
            return localized("pl_transaction_label_transStatCardAuth")
        case .executed:
            return localized("pl_transaction_label_transStatExecuted")
        case .processingToBeSent:
            return localized("pl_transaction_label_transStatToBeSent")
        case .processingSent:
            return localized("pl_transaction_label_transStatSent")
        case .rejected:
            return localized("pl_transaction_label_transStatRejected")
        default:
            return nil
        }
    }
}

public enum AccountTransactionState: String {
    case cardAuthorisation = "CARD_AUTHORISATION"
    case executed = "EXECUTED"
    case processingToBeSent = "PROCESSING_TO_BE_SENT"
    case processingSent = "PROCESSING_SENT"
    case rejected = "REJECTED"
}
