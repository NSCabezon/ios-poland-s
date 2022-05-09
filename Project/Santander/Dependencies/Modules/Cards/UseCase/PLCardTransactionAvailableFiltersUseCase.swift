//
//  PLCardTransactionAvailableFiltersUseCase.swift
//  Santander
//
//  Created by Gloria Cano López on 4/5/22.
//

import Foundation
import CoreDomain
import OpenCombine
import Cards

struct PLCardTransactionAvailableFiltersUseCase {
    
    func fetchAvailableFiltersPublisher() -> AnyPublisher<CardTransactionAvailableFiltersRepresentable, Never> {
        return Just(PLCardTransactionFilters()).eraseToAnyPublisher()
    }
}

extension PLCardTransactionAvailableFiltersUseCase: CardTransactionAvailableFiltersUseCase {
    struct PLCardTransactionFilters: CardTransactionAvailableFiltersRepresentable {
        var byAmount: Bool = true
        var byExpenses: Bool = true
        var byTypeOfMovement: Bool = false
        var byConcept: Bool = true
    }
}
