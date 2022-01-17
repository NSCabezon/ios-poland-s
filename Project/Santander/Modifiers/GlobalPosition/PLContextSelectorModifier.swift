//
//  PLContextSelectorModifier.swift
//  Santander
//

import GlobalPosition
import Commons
import UI
import SANPLLibrary
import SANLegacyLibrary
import PLUI
import RetailLegacy
import PLContexts

class PLContextSelectorModifier: ContextSelectorModifierProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let dataProvider: BSANDataProvider
    private let contextSelectorCoordinator: ContextSelectorCoordinator
    
    init(dependenciesResolver: DependenciesResolver, bsanDataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.dataProvider = bsanDataProvider
        guard let drawer = UIApplication.shared.keyWindow?.rootViewController as? BaseMenuViewController else {
            fatalError()
        }
        self.contextSelectorCoordinator = ContextSelectorCoordinator(resolver: self.dependenciesResolver,
                                                                     bsanDataProvider: self.dataProvider,
                                                                     coordinatingViewController: drawer.currentRootViewController as? UINavigationController)
    }
    
    var isContextSelectorEnabled: Bool {
        self.dataProvider.getCustomerIndividual()?.customerContexts?.isNotEmpty ?? false
    }
    
    var showContextSelector: Bool? {
        let customerContexts = self.dataProvider.getCustomerIndividual()?.customerContexts ?? []
        return customerContexts.count > 1
    }
    
    var contextName: String? {
        let customerContexts = self.dataProvider.getCustomerIndividual()?.customerContexts ?? []
        guard let contextSelected = customerContexts.first(where: { $0.selected ?? false }), contextSelected.type != .INDIVIDUAL else { return nil }
        return contextSelected.name
    }
    
    func pressedContextSelector() {
        self.contextSelectorCoordinator.start()
    }
}
