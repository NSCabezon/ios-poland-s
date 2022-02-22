//
//  CheckPhoneUseCase.swift
//  PhoneTopUp
//
//  Created by 188216 on 18/02/2022.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol CheckPhoneUseCaseProtocol: UseCase<CheckPhoneUseCaseInput, CheckPhoneUseCaseOutput, StringErrorOutput> {
}

final class CheckPhoneUseCase: UseCase<CheckPhoneUseCaseInput, CheckPhoneUseCaseOutput, StringErrorOutput> {
    // MARK: Properties
    
    private let managersProvider: PLManagersProviderProtocol
    private let phoneTopUpManager: PLPhoneTopUpManagerProtocol
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver) {
        self.managersProvider = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        self.phoneTopUpManager = managersProvider.getPhoneTopUpManager()
    }
    
    // MARK: Methods
    
    override func executeUseCase(requestValues: CheckPhoneUseCaseInput) throws -> UseCaseResponse<CheckPhoneUseCaseOutput, StringErrorOutput> {
        let request = CheckPhoneRequestDTO(operatorId: requestValues.operatorId,
                                           topUpNumber: requestValues.topUpNumber,
                                           reloadAmount: requestValues.reloadAmount)
        let results = try phoneTopUpManager.checkPhone(request: request)
        switch results {
        case .success(let responseDTO):
            return .ok(CheckPhoneUseCaseOutput(reloadPossible: responseDTO.reloadPossible, result: responseDTO.result))
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension CheckPhoneUseCase: CheckPhoneUseCaseProtocol {
}
