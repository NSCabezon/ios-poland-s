//
//  ModuleDependencies+SavingsExternalDependenciesResolver.swift
//  Santander
//
//  Created by Jose Ignacio de Juan Díaz on 6/4/22.
//

import SavingProducts
import CoreFoundationLib
import CoreDomain

extension ModuleDependencies: SavingsExternalDependenciesResolver {
    func resolve() -> SavingTransactionsRepository {
        fatalError()
    }
    
    func resolve() -> GetSavingProductOptionsUseCase {
        fatalError()
    }
    
    func resolve() -> GetSavingProductComplementaryDataUseCase {
        fatalError()
    }
}
