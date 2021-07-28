//
//  CardBalanceDTOAdapter.swift
//  PLLegacyAdapter
//
//  Created by Rodrigo Jurado on 2/7/21.
//

import SANPLLibrary
import SANLegacyLibrary

final class CardBalanceDTOAdapter {
    static func adaptPLBalance(_ plCard: SANPLLibrary.CardDTO) -> SANLegacyLibrary.CardBalanceDTO {
        var cardBalanceDTO = SANLegacyLibrary.CardBalanceDTO()
        cardBalanceDTO.availableAmount = AmountAdapter.adaptBalanceToAmount(plCard.availableBalance)
        cardBalanceDTO.currentBalance = AmountAdapter.adaptBalanceToAmount(plCard.disposedAmount)
        cardBalanceDTO.creditLimitAmount = AmountAdapter.adaptBalanceToAmount(plCard.creditLimit)
        return cardBalanceDTO
    }
}
