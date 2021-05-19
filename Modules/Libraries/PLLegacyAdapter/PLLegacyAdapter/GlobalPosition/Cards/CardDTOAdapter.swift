//
//  CardDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 18/5/21.
//

import Foundation
import SANPLLibrary
import SANLegacyLibrary

public final class CardDTOAdapter {
    func adaptPLCardToCardDTO(_ plCard: SANPLLibrary.CardDTO) -> SANLegacyLibrary.CardDTO {
        var cardDTO = SANLegacyLibrary.CardDTO()
        cardDTO.PAN = plCard.maskedPan
        cardDTO.alias = plCard.name?.userDefined
        cardDTO.cardContractStatusType = plCard.generalStatus?.lowercased() == "active" ? CardContractStatusType.active : CardContractStatusType.other
        cardDTO.contract = ContractDTO(bankCode: "", branchCode: "", product: "", contractNumber: plCard.virtualPan)
        cardDTO.cardTypeDescription = plCard.type
        return cardDTO
    }

    func adaptPLCardToCardDataDTO(_ plCard: SANPLLibrary.CardDTO) -> SANLegacyLibrary.CardDataDTO {
        var cardDataDTO = SANLegacyLibrary.CardDataDTO()
        cardDataDTO.PAN = plCard.maskedPan
        let amountAdapter = AmountAdapter()
        cardDataDTO.availableAmount = amountAdapter.adaptBalanceToAmount(plCard.availableBalance)
        cardDataDTO.currentBalance = amountAdapter.adaptBalanceToAmount(plCard.disposedAmount)
        cardDataDTO.creditLimitAmount = amountAdapter.adaptBalanceToAmount(plCard.creditLimit)
        cardDataDTO.visualCode = plCard.productCode
        if plCard.type?.lowercased() == "credit" {
            var amount = amountAdapter.adaptBalanceToAmount(plCard.disposedAmount)
            amount?.value?.negate()
            cardDataDTO.currentBalance = amount
        } else {
            cardDataDTO.currentBalance = amountAdapter.adaptBalanceToAmount(plCard.disposedAmount)
        }
        return cardDataDTO
    }

    func adaptPLCardToInactiveCard(_ plCard: SANPLLibrary.CardDTO) -> SANLegacyLibrary.InactiveCardDTO {
        var inactiveCardDTO = SANLegacyLibrary.InactiveCardDTO()
        inactiveCardDTO.PAN = plCard.maskedPan
        inactiveCardDTO.cardDescription = plCard.name?.userDefined
        inactiveCardDTO.inactiveCardType = .temporallyOff
        return inactiveCardDTO
    }
}
