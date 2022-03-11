//
//  PLSessionDataManagerModifier.swift
//  Santander
//
//  Created by Hernán Villamil on 10/11/21.
//

import CoreFoundationLib

final class PLSessionDataManagerModifier: SessionDataManagerModifier {
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private var productActionsShortcutsMatrix = ProductActionsShortcutsMatrix(operations: nil)
    
    init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
    }
    
    func performAfterGlobalPosition(_ globalPosition: GlobalPositionRepresentable) -> ScenarioHandler<Void, StringErrorOutput>? {
        let useCaseHandler: UseCaseScheduler = self.dependenciesEngine.resolve()
        let actionsShortcutsUseCase = PLProductActionsShortcutsUseCase(dependenciesResolver: self.dependenciesEngine)
        let productMatrixScenario = Scenario(useCase: actionsShortcutsUseCase, input: PLProductActionsShortcutsUseCaseInput(useCache: false))
        return productMatrixScenario.execute(on: useCaseHandler)
            .onSuccess { [weak self] productMatrix in
                self?.productActionsShortcutsMatrix = productMatrix
                self?.registerProductMatrix()
            }
            .map({ _ in return })
    }
    
    func performBeforePullOffers() -> ScenarioHandler<Bool, StringErrorOutput>? {
        return ScenarioHandler(scheduler: dependenciesEngine.resolve()).just(true)
    }
    
    func performBeforeFinishing() -> ScenarioHandler<Void, StringErrorOutput>? {
        return nil
    }
}

private extension PLSessionDataManagerModifier {
    func registerProductMatrix() {
        dependenciesEngine.register(for: ProductActionsShortcutsMatrix.self, with: { _ in
            return self.productActionsShortcutsMatrix
        })
    }
}
