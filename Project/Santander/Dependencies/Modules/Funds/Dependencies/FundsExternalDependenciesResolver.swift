//
//  FundsExternalDependenciesResolver.swift
//  Santander
//

import UI
import Funds
import CoreFoundationLib
import CoreDomain

extension ModuleDependencies: FundsExternalDependenciesResolver {

    var common: FundsCommonExternalDependenciesResolver {
        return self
    }

    func resolve() -> FundReactiveRepository {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }

    func resolve() -> FundsHomeHeaderModifier? {
        return PLFundsHomeHeaderModifier()
    }

    func resolve() -> FundsHomeMovementsModifier? {
        return PLFundsHomeMovementsModifier()
    }

    func resolve() -> GetFundOptionsUsecase {
        return PLGetFundOptionsUsecase()
    }

    func fundCustomeOptionCoordinator() -> BindableCoordinator {
        return FundCustomeOptionCoordinator()
    }

    func resolve() -> FundsDetailFieldsModifier? {
        PLFundsDetailFieldsModifier()
    }

    func resolve() -> FundMovementDetailFieldsModifier? {
        return nil
    }

    func resolve() -> FundsTransactionsFilterModifier? {
        PLFundsTransactionsFilterModifier()
    }
}
