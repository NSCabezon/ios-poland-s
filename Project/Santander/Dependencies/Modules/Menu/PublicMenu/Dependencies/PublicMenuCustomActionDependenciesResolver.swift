//
//  PublicMenuCustomActionDependenciesResolver.swift
//  Santander
//
//  Created by Juan Jose Acosta González on 31/1/22.
//
import Menu
import UI
import CoreFoundationLib

protocol PublicMenuCustomActionDependenciesResolver {
    func resolve() -> DataBinding
}
