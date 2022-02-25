//
//  SaveBlikTransactionDataVisibilityUseCase.swift
//  BLIK
//
//  Created by 185167 on 21/02/2022.
//

import CoreFoundationLib
import Foundation
import SANPLLibrary

protocol SaveBlikTransactionDataVisibilityUseCaseProtocol: UseCase<SaveBlikTransactionVisibilityInput, Void, StringErrorOutput> {}

final class SaveBlikTransactionDataVisibilityUseCase: UseCase<SaveBlikTransactionVisibilityInput, Void, StringErrorOutput> {
    private let dependenciesResolver: DependenciesResolver
    private var managersProvider: PLManagersProviderProtocol {
        dependenciesResolver.resolve()
    }
    
    private var requestMapper: RegisterAliasParametersMapping {
        dependenciesResolver.resolve()
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    override func executeUseCase(requestValues: SaveBlikTransactionVisibilityInput) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let parameters = SetNoPinTrnVisibleParameters(noPinTrnVisible: requestValues.isBlikTransactionDataVisibleBeforeSignIn)
        let result = try managersProvider.getBLIKManager().setTransactionDataVisibility(parameters)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

struct SaveBlikTransactionVisibilityInput {
    let isBlikTransactionDataVisibleBeforeSignIn: Bool
}

extension SaveBlikTransactionDataVisibilityUseCase: SaveBlikTransactionDataVisibilityUseCaseProtocol {}
