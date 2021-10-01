//
//  CardDetailDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Juan Sánchez Marín on 21/9/21.
//

import SANPLLibrary
import SANLegacyLibrary
import Commons

final class CardDetailDTOAdapter {

    static func adaptPLCardToCardDetail(_ plCard: SANPLLibrary.CardDetailDTO) -> SANLegacyLibrary.CardDetailDTO {
        var cardDataDTO = SANLegacyLibrary.CardDetailDTO()
        cardDataDTO.availableAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.relatedAccountData?.availableFunds)
        cardDataDTO.currentBalance = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.relatedAccountData?.balance)
        cardDataDTO.creditLimitAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.relatedAccountData?.creditLimit)
        cardDataDTO.holder = plCard.emboss1 + " " + plCard.emboss2

        cardDataDTO.beneficiary = plCard.emboss1 + " " + plCard.emboss2
        cardDataDTO.expirationDate = DateFormats.toDate(string: plCard.cardExpirationDate ?? "", output: DateFormats.TimeFormat.YYYYMMDD)
        cardDataDTO.currency = plCard.relatedAccountData?.availableFunds?.currencyCode
        cardDataDTO.creditCardAccountNumber = plCard.relatedAccountData?.accountNo
        return cardDataDTO
    }
}
