//
//  PLCardOperativesManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/10/21.
//

import SANLegacyLibrary

// MARK: - PLCardOperativesManagerProtocol
public protocol PLCardOperativesManagerProtocol {
    func blockCard(cardId: String) throws -> Result<Void, NetworkProviderError>
    func unblockCard(cardId: String) throws -> Result<Void, NetworkProviderError>
    func disableCard(cardId: String, reason: CardDisableReason) throws -> Result<Void, NetworkProviderError>
}

final class PLCardOperativesManager {
    private let cardOperativesDataSource: CardOperativesDataSource
    private let bsanDataProvider: BSANDataProvider

    public init(bsanDataProvider: BSANDataProvider, networkProvider: NetworkProvider) {
        self.cardOperativesDataSource = CardOperativesDataSource(networkProvider: networkProvider, dataProvider: bsanDataProvider)
        self.bsanDataProvider = bsanDataProvider
    }
}

// MARK: -  PLCardOperativesManager

extension PLCardOperativesManager: PLCardOperativesManagerProtocol {

    func blockCard(cardId: String) throws -> Result<Void, NetworkProviderError> {
        let parameters: CardBlockParameters = CardBlockParameters(virtualPan: cardId)
        let result = try self.cardOperativesDataSource.postCardBlock(parameters)
        return result
    }

    func unblockCard(cardId: String) throws -> Result<Void, NetworkProviderError> {
        let parameters: CardUnblockParameters = CardUnblockParameters(virtualPan: cardId)
        let result = try self.cardOperativesDataSource.postCardUnblock(parameters)
        return result
    }

    func disableCard(cardId: String, reason: CardDisableReason) throws -> Result<Void, NetworkProviderError> {
        let parameters: CardDisableParameters = CardDisableParameters(virtualPan: cardId, reason: reason)
        let result = try self.cardOperativesDataSource.postCardDisable(parameters)
        return result
    }
}
