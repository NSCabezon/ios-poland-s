//
//  AcceptTopUpTransactionUseCase.swift
//  PhoneTopUp
//
//  Created by 188216 on 21/02/2022.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol PerformTopUpTransactionUseCaseProtocol: UseCase<PerformTopUpTransactionUseCaseInput, PerformTopUpTransactionUseCaseOutput, StringErrorOutput> {
}

final class PerformTopUpTransactionUseCase: UseCase<PerformTopUpTransactionUseCaseInput, PerformTopUpTransactionUseCaseOutput, StringErrorOutput> {
    // MARK: Properties
    
    private let managersProvider: PLManagersProviderProtocol
    private let transfersManager: PLTransfersManagerProtocol
    private let topUpManager: PLPhoneTopUpManagerProtocol
    private let inputMapper: AcceptTopUpTransactionInputMapping
    private let topUpSuccessStatus = "RELOAD_SUCCESSFUL"
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.transfersManager = managersProvider.getTransferManager()
        self.topUpManager = managersProvider.getPhoneTopUpManager()
        self.inputMapper = dependenciesResolver.resolve(for: AcceptTopUpTransactionInputMapping.self)
    }
    
    // MARK: Methods
    
    override func executeUseCase(requestValues: PerformTopUpTransactionUseCaseInput) throws -> UseCaseResponse<PerformTopUpTransactionUseCaseOutput, StringErrorOutput> {
        let transferParameters = inputMapper.map(with: requestValues)
        let reloadParameters = ReloadPhoneRequestDTO(operatorId: requestValues.operatorId, topUpNumber: requestValues.recipientNumber, reloadAmount: requestValues.amount)
        let transferResults = try transfersManager.sendConfirmation(transferParameters)
        let reloadResults = try topUpManager.reloadPhone(request: reloadParameters)

        switch (transferResults, reloadResults) {
        case (.success(_), .success(let reloadResponse)):
            return .ok(PerformTopUpTransactionUseCaseOutput(reloadSuccessful: reloadResponse.result == topUpSuccessStatus))
        case (_, .failure(let reloadError)):
            return .error(.init(reloadError.localizedDescription))
        case (.failure(let transferError), _):
            return .error(.init(transferError.localizedDescription))
        }
    }
}

extension PerformTopUpTransactionUseCase: PerformTopUpTransactionUseCaseProtocol {
}
