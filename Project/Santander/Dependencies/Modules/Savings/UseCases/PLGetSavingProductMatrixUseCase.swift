//
//  PLGetSavingProductShortcutsUseCase.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 27/4/22.
//

import Loans
import CoreFoundationLib
import CoreDomain
import Foundation
import OpenCombine
import SANPLLibrary

struct PLGetSavingProductMatrixUseCase {
    let resolver: DependenciesResolver
    
    init(resolver: DependenciesResolver) {
        self.resolver = resolver
    }
    
    func fetchShortcutsConfiguration(for contract: String)  -> AnyPublisher<[OperationsProductsStatesDTO], Never> {
        let manager = resolver.resolve(for: PLManagersProviderProtocol.self).getOperationsProductsManager()
        let request = try? manager.getOperationsProducts(useCache: true)
        switch request {
        case .success(let operations):
            return Just(ProductActionsShortcutsMatrix(operations: operations).getOperationsProducts(type: .savings, contract: contract) ?? []).eraseToAnyPublisher()
        default:
            return Just([]).eraseToAnyPublisher()
        }
    }
}
