//
//  PLCardsManager.swift
//  SANPLLibrary
//

import SANLegacyLibrary

// MARK: - PLCardsManagerProtocol Protocol

public protocol PLCardsManagerProtocol {
    func getCards() -> [CardDTO]?
}

final class PLCardsManager {
    private let bsanDataProvider: BSANDataProvider

    public init(bsanDataProvider: BSANDataProvider) {
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

}
