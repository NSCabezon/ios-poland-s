//
//  LoanExternalDependenciesResolver.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/30/21.
//
import UI
import Loans
import Commons
import CoreDomain
import Foundation

extension ModuleDependencies: LoanExternalDependenciesResolver {
    func resolve() -> LoanReactiveRepository {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
    
    func resolve() -> LoansModifierProtocol? {
        return PLLoanModifier()
    }
    
    func resolve() -> GetLoanOptionsUsecase {
        return PLGetLoanOptionsUsecase()
    }
    
    func loanCustomeOptionCoordinator() -> BindableCoordinator {
        return LoanCustomeOptionCoordinator(dependencies: self)
    }
}
