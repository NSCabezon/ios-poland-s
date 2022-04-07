//
//  LoanExternalDependenciesResolver.swift
//  Santander
//
//  Created by Juan Carlos López Robles on 12/30/21.
//
import UI
import Loans
import CoreFoundationLib
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

    func resolve() -> GetLoanTransactionDetailConfigurationUseCase {
        return PLGetLoanTransactionDetailConfigurationUseCase()
    }

    func resolve() -> GetLoanTransactionDetailActionUseCase {
        return PLGetLoanTransactionDetailConfigurationUseCase()
    }

    func resolve() -> GetLoanPDFInfoUseCase {
        return PLGetLoanPDFInfoUseCase(dependenciesResolver: resolve())
    }

    func resolve() -> LoanDetailConfigRepresentable {
        return LoanDetailConfig()
    }

    func resolve() -> GetLoanTransactionSearchConfigUseCase {
        return PLGetLoanTransactionSearchConfigUseCase()
    }
}
