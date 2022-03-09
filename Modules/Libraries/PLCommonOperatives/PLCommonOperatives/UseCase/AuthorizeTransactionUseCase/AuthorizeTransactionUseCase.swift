//
//  AuthorizeTransactionUseCase.swift
//  PhoneTopUp
//
//  Created by 188216 on 25/02/2022.
//

import Foundation
import CoreDomain
import CoreFoundationLib
import SANPLLibrary

public protocol AuthorizeTopUpTransactionUseCaseProtocol: UseCase<AuthorizeTransactionUseCaseInput, AuthorizeTransactionUseCaseOutput, StringErrorOutput> {
}

public final class AuthorizeTopUpTransactionUseCase: UseCase<AuthorizeTransactionUseCaseInput, AuthorizeTransactionUseCaseOutput, StringErrorOutput> {
    // MARK: Properties
    
    private let managersProvider: PLManagersProviderProtocol
    private let transferRepository: PLTransfersRepository
    private let authorizationManager: PLAuthorizationProcessorManagerProtocol
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.transferRepository = dependenciesResolver.resolve(for: PLTransfersRepository.self)
        self.authorizationManager = managersProvider.getAuthorizationProcessorManager()
    }
    
    // MARK: Methods
    
    public override func executeUseCase(requestValues: AuthorizeTransactionUseCaseInput) throws -> UseCaseResponse<AuthorizeTransactionUseCaseOutput, StringErrorOutput> {
        let authorizationResults = try transferRepository.getChallenge(parameters: requestValues.sendMoneyConfirmationInput)
            .flatMapError({ _ in
                return .failure(NetworkProviderError.other)
            })
            .flatMap { [weak self] challenge -> Result<AuthorizationIdRepresentable, NetworkProviderError> in
                guard let self = self, let challenge = challenge.challengeRepresentable else {
                    return .failure(NetworkProviderError.other)
                }
                
                let notifyDeviceInput = NotifyDeviceInput(partialInput: requestValues.partialNotifyDeviceInput, challenge: challenge)
                do {
                    return try self.transferRepository.notifyDevice(notifyDeviceInput)
                } catch {
                    return .failure(NetworkProviderError.other)
                }
            }
            .flatMap { [weak self] authorizationId -> Result<(Int, ChallengeRepresentable), NetworkProviderError> in
                guard let self = self, let authorizationId = authorizationId.authorizationId else {
                    return .failure(NetworkProviderError.other)
                }
                
                do {
                    return try self.authorizationManager.getPendingChallenge()
                        .map({ challenge -> (Int, ChallengeRepresentable) in
                            return (authorizationId, challenge)
                        })
                } catch {
                    return .failure(NetworkProviderError.other)
                }
            }
        
        switch authorizationResults {
        case .success(let results):
            return .ok(AuthorizeTransactionUseCaseOutput(pendingChallenge: results.1, authorizationId: results.0))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension AuthorizeTopUpTransactionUseCase: AuthorizeTopUpTransactionUseCaseProtocol {
}
