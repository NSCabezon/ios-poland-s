//
//  PLContextSelectorModifier.swift
//  Santander
//

import GlobalPosition
import CoreFoundationLib
import UI
import SANPLLibrary
import SANLegacyLibrary
import PLUI
import RetailLegacy
import PLContexts

class PLContextSelectorModifier: ContextSelectorModifierProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let dataProvider: BSANDataProvider

    init(dependenciesResolver: DependenciesResolver, bsanDataProvider: BSANDataProvider) {
        self.dependenciesResolver = dependenciesResolver
        self.dataProvider = bsanDataProvider
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
        let drawer = UIApplication.shared.keyWindow?.rootViewController as? BaseMenuViewController
        let contextSelectorCoordinator = ContextSelectorCoordinator(resolver: self.dependenciesResolver, bsanDataProvider: self.dataProvider, coordinatingViewController: drawer?.currentRootViewController as? UINavigationController)
        contextSelectorCoordinator.start()
    }
}
