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
        globalPositionDTO.cards = cards

        return globalPositionDTO
    }
}
