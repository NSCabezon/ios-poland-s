//
//  PLProductActionsShortcutsUseCase.swift
//  PLCommons
//
//  Created by Mario Rosales Maillo on 12/1/22.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary

public final class PLProductActionsShortcutsUseCase: UseCase<PLProductActionsShortcutsUseCaseInput, ProductActionsShortcutsMatrix, StringErrorOutput> {
    
    private let dependenciesResolver: DependenciesResolver
    private let appConfig: AppConfigRepositoryProtocol
    
    public init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.appConfig = self.dependenciesResolver.resolve()
    }
    
    public override func executeUseCase(requestValues: PLProductActionsShortcutsUseCaseInput) throws -> UseCaseResponse<ProductActionsShortcutsMatrix, StringErrorOutput> {
        
        let managerProvider: PLManagersProviderProtocol = self.dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
        do {
            let productOperations = try managerProvider.getOperationsProductsManager().getOperationsProducts(useCache: requestValues.useCache)
            switch productOperations {
            case .success(let operations):
                if operations.isEmpty == false {
                    return .ok(ProductActionsShortcutsMatrix(operations: operations))
                } else {
                    return .error(StringErrorOutput("Empty operations"))
                }
            case .failure(let error):
                return .error(StringErrorOutput(error.localizedDescription))
            }
        } catch {
            return .error(StringErrorOutput("Error getting operations"))
        }
    }
}

public struct PLProductActionsShortcutsUseCaseInput {
    let useCache: Bool
    public init(useCache: Bool) {
        self.useCache = useCache
    }
}
