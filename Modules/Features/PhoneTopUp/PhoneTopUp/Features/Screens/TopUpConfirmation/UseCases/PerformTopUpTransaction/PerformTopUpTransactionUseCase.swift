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
    private let inputMapper: PerformTopUpTransactionInputMapping
    private let topUpSuccessStatus = "RELOAD_SUCCESSFUL"
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.transfersManager = managersProvider.getTransferManager()
        self.topUpManager = managersProvider.getPhoneTopUpManager()
        self.inputMapper = dependenciesResolver.resolve(for: PerformTopUpTransactionInputMapping.self)
    }
    
    // MARK: Methods
    
    override func executeUseCase(requestValues: PerformTopUpTransactionUseCaseInput) throws -> UseCaseResponse<PerformTopUpTransactionUseCaseOutput, StringErrorOutput> {
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return .error(.init("userId not exists"))
        }
        let transferParameters = inputMapper.mapSendMoneyConfirmationInput(with: requestValues, userId: userId)
        let reloadParameters = ReloadPhoneRequestDTO(operatorId: requestValues.operatorId, topUpNumber: requestValues.recipientNumber, reloadAmount: requestValues.amount)
        
        let topupResults = try transfersManager.sendConfirmation(transferParameters)
            .flatMap({ [weak self] _ -> Result<ReloadPhoneResponseDTO, NetworkProviderError> in
                guard let self = self else {
                    return .failure(NetworkProviderError.other)
                }
                
                do {
                    return try self.topUpManager.reloadPhone(request: reloadParameters)
                } catch let error as NetworkProviderError {
                    return .failure(error)
                } catch {
                    return .failure(NetworkProviderError.other)
                }
            })

        switch topupResults {
        case .success(let reloadResponse):
            return .ok(PerformTopUpTransactionUseCaseOutput(reloadSuccessful: reloadResponse.result == topUpSuccessStatus))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension PerformTopUpTransactionUseCase: PerformTopUpTransactionUseCaseProtocol {
}
