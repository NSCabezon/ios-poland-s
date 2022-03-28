//
//  PLGetLoanTransactionSearchConfig.swift
//  Santander
//
//  Created by Juan Jose Acosta on 18/3/22.
//

import Foundation
import OpenCombine
import CoreDomain
import Loans

struct PLGetLoanTransactionSearchConfigUseCase: GetLoanTransactionSearchConfigUseCase {
    func fetchConfiguration() -> AnyPublisher<LoanTransactionSearchConfigRepresentable, Never> {
        return Just(PLLoanTransactionSearchConfig()).eraseToAnyPublisher()
    }
}

private extension PLGetLoanTransactionSearchConfigUseCase {
    struct PLLoanTransactionSearchConfig: LoanTransactionSearchConfigRepresentable {
        var isFiltersEnabled: Bool = true
        var isEnabledConceptFilter: Bool = false
        var isEnabledOperationTypeFilter: Bool = false
        var isEnabledAmountRangeFilter: Bool = true
        var isEnabledDateFilter: Bool = true
        var isDetailsCarouselEnabled: Bool = true
    }
}
