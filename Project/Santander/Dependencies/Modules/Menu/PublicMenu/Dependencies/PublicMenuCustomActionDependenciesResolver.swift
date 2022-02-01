//
//  PublicMenuCustomActionDependenciesResolver.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 31/1/22.
//
import Menu
import UI
import Commons

protocol PublicMenuCustomActionDependenciesResolver {
    var externalDependencies: PublicMenuCustomActionExternalDependenciesResolver { get }
    func resolve() -> DataBinding
}
