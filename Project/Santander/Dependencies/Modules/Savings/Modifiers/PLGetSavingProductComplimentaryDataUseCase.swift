//
//  PLGetSavingProductComplimentaryDataUseCase.swift
//  Santander
//
//  Created by crodrigueza on 8/4/22.
//

import SavingProducts
import OpenCombine
import CoreDomain

struct PLGetSavingProductComplimentaryDataUseCase: GetSavingProductComplementaryDataUseCase {
    private var repository: GlobalPositionDataRepository

    func fechComplementaryDataPublisher() -> AnyPublisher<[String: [DetailTitleLabelType]], Never> {
        return Just([
            PLSavingTransactionsRepositoryProductType.savingProduct.rawValue: [.interestRate],
            PLSavingTransactionsRepositoryProductType.term.rawValue: [.interestRate]
        ]).eraseToAnyPublisher()
    }

    init(dependencies: SavingsHomeExternalDependenciesResolver) {
        repository = dependencies.resolve()
    }
}
