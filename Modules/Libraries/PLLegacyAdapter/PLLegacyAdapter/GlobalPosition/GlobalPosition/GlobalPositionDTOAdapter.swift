//
//  GlobalPositionDTOAdapter.swift
//  PLLegacyAdapter
//

import SANPLLibrary
import SANLegacyLibrary

final class GlobalPositionDTOAdapter {
    func adaptPLGlobalPositionToGlobalPosition(_ plGlobalPosition: SANPLLibrary.GlobalPositionDTO) -> SANLegacyLibrary.GlobalPositionDTO {
        var globalPositionDTO = SANLegacyLibrary.GlobalPositionDTO()
        let cards = plGlobalPosition.cards?.compactMap({ card -> SANLegacyLibrary.CardDTO? in
            let cardDTOAdapter = CardDTOAdapter()
            return cardDTOAdapter.adaptPLCardToCard(card)
        })
        let loans = plGlobalPosition.loans?.compactMap({ loan -> SANLegacyLibrary.LoanDTO? in
            let loanDTOAdapter = LoanDTOAdapter()
            return loanDTOAdapter.adaptPLLoanToLoan(loan)
        })
        globalPositionDTO.cards = cards
        globalPositionDTO.loans = loans

        return globalPositionDTO
    }
}
