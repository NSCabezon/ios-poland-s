//
//  RegisterAliasUseCase.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 13/09/2021.
//

import CoreFoundationLib
import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol UpdateAliasUseCaseProtocol: UseCase<BlikAlias, Void, StringErrorOutput> {}

final class UpdateAliasUseCase: UseCase<BlikAlias, Void, StringErrorOutput> {
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
    
    override func executeUseCase(requestValues: BlikAlias) throws -> UseCaseResponse<Void, StringErrorOutput> {
        let request = requestMapper.map(requestValues)
        let result = try managersProvider.getBLIKManager().registerAlias(request)
        switch result {
        case .success:
            return .ok()
        case .failure(let error):
            return .error(.init(error.localizedDescription))
        }
    }
}

extension UpdateAliasUseCase: UpdateAliasUseCaseProtocol {}

