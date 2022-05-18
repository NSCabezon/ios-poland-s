//
//  PLGetSavingProductsUsecase.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 20/4/22.
//

import Foundation
import SavingProducts
import CoreDomain
import OpenCombine

struct PLGetSavingProductsUsecase {
    private var repository: GlobalPositionDataRepository
    
    init(dependencies: SavingsHomeExternalDependenciesResolver) {
        self.repository = dependencies.resolve()
    }
}

extension PLGetSavingProductsUsecase: GetSavingProductsUsecase {
    func fechSavingProducts() -> AnyPublisher<[SavingProductRepresentable], Never> {
        return repository.getGlobalPosition()
            .map(\.savingProductRepresentables)
            .map({ products in
                return products.filter { product in
                    product.accountSubType != PLSavingTransactionsRepositoryProductType.goals.rawValue
                }
            })
            .eraseToAnyPublisher()
    }
}
