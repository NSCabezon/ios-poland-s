//
//  PLCardsManager.swift
//  SANPLLibrary
//

import SANLegacyLibrary

// MARK: - PLCardsManagerProtocol Protocol

public protocol PLCardsManagerProtocol {
    func getCards() -> [CardDTO]?
    func loadCardPAN(cardId: String) -> String?
    func getCardDetail(cardId: String) throws -> Result<CardDetailDTO, NetworkProviderError>
}

final class PLCardsManager {
    private let cardDetailDataSource: CardDetailDataSourceProtocol
    private let bsanDataProvider: BSANDataProvider

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.cardDetailDataSource = CardDetailDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
    }
}

// MARK: -  PLCardsManagerProtocol

extension PLCardsManager: PLCardsManagerProtocol {

    func getCards() -> [CardDTO]? {
        guard let sessionData = try? self.bsanDataProvider.getSessionData(),
              let cardDTO = sessionData.globalPositionDTO?.cards else {
            return nil
        }
        return cardDTO
    }

    func loadCardPAN(cardId: String) -> String? {
        return bsanDataProvider.getCardPAN(cardId: cardId)
    }

    func getCardDetail(cardId: String) throws -> Result<CardDetailDTO, NetworkProviderError> {
        let parameters: CardDetailParameters = CardDetailParameters(virtualPan: cardId)
        let result = try self.cardDetailDataSource.getCardDetail(parameters)
        return result
    }
}
