//
//  PLSessionDataManagerModifier.swift
//  Santander
//
//  Created by Hernán Villamil on 10/11/21.
//

import Commons
import CoreFoundationLib
import Models

final class PLSessionDataManagerModifier: SessionDataManagerModifier {
    private let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func performAfterGlobalPosition(_ globalPosition: GlobalPositionRepresentable) -> ScenarioHandler<Void, StringErrorOutput>? {
        return nil
    }
    
    func performBeforePullOffers() -> ScenarioHandler<Bool, StringErrorOutput>? {
        return ScenarioHandler(scheduler: dependenciesResolver.resolve()).just(true)
    }
    
    func performBeforeFinishing() -> ScenarioHandler<Void, StringErrorOutput>? {
        return nil
    }
}
