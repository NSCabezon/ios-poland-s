//
//  AccountTransactionDetailDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary
import PLCommons
import Commons

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
        if let state = accountTransaction.status, !state.isBlank {
            literals.append(LiteralDTO(concept: state, literal: localized("transaction_label_statusDetail")))
        }
        if let senderDataConcept = accountTransaction.senderData, !senderDataConcept.isBlank {
            literals.append(LiteralDTO(concept: senderDataConcept, literal: localized("pl_cardDetail_label_senderData")))
        }
        if let senderAccountNumberConcept = accountTransaction.senderAccountNumber, !senderAccountNumberConcept.isBlank {
            literals.append(LiteralDTO(concept: IBANFormatter.format(iban: senderAccountNumberConcept), literal: localized("pl_cardDetail_label_senderAccountNumber")))
        }
        accountTransactionDetailDTO.literalDTOs = literals
        return accountTransactionDetailDTO
    }
}
