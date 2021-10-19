//
//  CardDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 18/5/21.
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary

final class CardDTOAdapter {
    static func adaptPLCardToCard(_ plCard: SANPLLibrary.CardDTO) -> SANLegacyLibrary.CardDTO {
        var cardDTO = SANLegacyLibrary.CardDTO()
        cardDTO.PAN = plCard.maskedPan
        cardDTO.alias = plCard.name?.userDefined
        cardDTO.ownershipTypeDesc = OwnershipTypeDesc(plCard.role ?? "")
        cardDTO.ownershipType = OwnershipType.holder.type
        cardDTO.allowsDirectMoney = plCard.type?.lowercased() == "credit"
        cardDTO.statusDescription = plCard.generalStatus
        switch plCard.generalStatus?.lowercased() {
        case "active":
            cardDTO.cardContractStatusType = .active
        case "inactive":
            cardDTO.cardContractStatusType = .other
        case "blocked":
            cardDTO.cardContractStatusType = .blocked
        case "cancelled":
            cardDTO.cardContractStatusType = .cancelled
        default:
            cardDTO.cardContractStatusType = .cancelled
        }
        cardDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plCard.virtualPan)
        cardDTO.cardTypeDescription = plCard.type
        return cardDTO
    }

    static func adaptPLCardToCardData(_ plCard: SANPLLibrary.CardDTO) -> SANLegacyLibrary.CardDataDTO {
        var cardDataDTO = SANLegacyLibrary.CardDataDTO()
        cardDataDTO.PAN = repeatElement("X", count: Constants.maskedPANLength).joined() + String(plCard.maskedPan?.suffix(Constants.visiblePANDigits) ?? "")
        cardDataDTO.availableAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.availableBalance)
        cardDataDTO.currentBalance = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.disposedAmount)
        cardDataDTO.creditLimitAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.creditLimit)
        cardDataDTO.visualCode = plCard.productCode
        if plCard.type?.lowercased() == "credit" {
            var amount = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.disposedAmount)
            amount?.value?.negate()
            cardDataDTO.currentBalance = amount
        } else {
            cardDataDTO.currentBalance = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.disposedAmount)
        }
        return cardDataDTO
    }

    static func adaptPLCardToInactiveCard(_ plCard: SANPLLibrary.CardDTO) -> SANLegacyLibrary.InactiveCardDTO {
        var inactiveCardDTO = SANLegacyLibrary.InactiveCardDTO()
        inactiveCardDTO.PAN = plCard.maskedPan
        inactiveCardDTO.cardDescription = plCard.name?.userDefined
        inactiveCardDTO.inactiveCardType = .temporallyOff
        return inactiveCardDTO
    }
}

private extension CardDTOAdapter {
    enum Constants {
        static let maskedPANLength: Int = 12
        static let visiblePANDigits: Int = 4
    }
}
