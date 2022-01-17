//
//  CardDataDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 1/7/21.
//

import SANPLLibrary
import SANLegacyLibrary

final class CardDataDTOAdapter {
    static func adaptPLCardToCard(_ plCard: SANPLLibrary.CardDTO, customer: String?) -> SANLegacyLibrary.CardDataDTO {
        var cardDataDTO = self.createFromCardSuperSpeedDTO(plCard)
        cardDataDTO.PAN = plCard.maskedPan
        cardDataDTO.availableAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.availableBalance)
        cardDataDTO.currentBalance = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.disposedAmount)
        cardDataDTO.creditLimitAmount = AmountAdapter.adaptBalanceToCounterValueAmount(plCard.relatedAccountData?.creditLimit)
        cardDataDTO.visualCode = plCard.productCode
        if let customer = customer {
            cardDataDTO.stampedName = customer
        }
        return cardDataDTO
    }
}

private extension CardDataDTOAdapter {
    static func createFromCardSuperSpeedDTO(_ plCard: SANPLLibrary.CardDTO) -> CardDataDTO {
        var superSpeedDTO = CardSuperSpeedDTO()
        let expirationDate = plCard.expirationDate?.components(separatedBy: "-").joined().dropLast(2)
        superSpeedDTO.expirationDate = String(expirationDate ?? "")
        superSpeedDTO.dailyCashierLimit = AmountDTO(value: 0, currency: .create("PLN"))
        superSpeedDTO.dailyDebitLimit = AmountDTO(value: 0, currency: .create("PLN"))
        superSpeedDTO.qualityParticipation = "01"
        return CardDataDTO.createFromCardSuperSpeedDTO(from: superSpeedDTO)
    }
}
