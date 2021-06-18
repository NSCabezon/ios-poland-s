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
        cardDTO.cardContractStatusType = plCard.generalStatus?.lowercased() == "active" ? CardContractStatusType.active : CardContractStatusType.other
        cardDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plCard.virtualPan)
        cardDTO.cardTypeDescription = plCard.type
        return cardDTO
    }

    static func adaptPLCardToCardData(_ plCard: SANPLLibrary.CardDTO) -> SANLegacyLibrary.CardDataDTO {
        var cardDataDTO = SANLegacyLibrary.CardDataDTO()
        cardDataDTO.PAN = plCard.maskedPan
        cardDataDTO.availableAmount = AmountAdapter.adaptBalanceToAmount(plCard.availableBalance)
        cardDataDTO.currentBalance = AmountAdapter.adaptBalanceToAmount(plCard.disposedAmount)
        cardDataDTO.creditLimitAmount = AmountAdapter.adaptBalanceToAmount(plCard.creditLimit)
        cardDataDTO.visualCode = plCard.productCode
        if plCard.type?.lowercased() == "credit" {
            var amount = AmountAdapter.adaptBalanceToAmount(plCard.disposedAmount)
            amount?.value?.negate()
            cardDataDTO.currentBalance = amount
        } else {
            cardDataDTO.currentBalance = AmountAdapter.adaptBalanceToAmount(plCard.disposedAmount)
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
