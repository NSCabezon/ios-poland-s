//
//  PLCustomSavingsHomeCoordinator.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 25/4/22.
//

import Foundation
import PLCommons
import SavingProducts
import CoreFoundationLib
import SANLegacyLibrary
import CoreDomain
import UI

final class PLCustomSavingsHomeCoordinator: SavingsHomeCoordinator {
    
    private let defaultCoordinator: SavingsHomeCoordinator
    private let dependencies: ModuleDependencies
    var childCoordinators: [Coordinator] = [] {
        didSet {
            defaultCoordinator.childCoordinators = childCoordinators
        }
    }
    var navigationController: UINavigationController?
    var onFinish: (() -> Void)? {
        didSet {
            defaultCoordinator.onFinish = onFinish
        }
    }
    var dataBinding: DataBinding {
        return defaultCoordinator.dataBinding
    }
    
    init(dependencies: ModuleDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.defaultCoordinator = dependencies.defaultSavingsHomeCoordinator()
        self.navigationController = navigationController
    }
    
    func start() {
        guard let product: SavingProductRepresentable = dataBinding.get(),
                product.accountSubType == PLSavingTransactionsRepositoryProductType.goals.rawValue else {
            defaultCoordinator.navigationController = navigationController
            defaultCoordinator.start()
            return
        }
        guard let productId = product.accountId,
              let link = linkHandlerFor(productId: productId) else { return }
        (dependencies.resolve() as PLWebViewCoordinatorDelegate).showWebView(handler: link)
    }
    
    func openMenu() {
        defaultCoordinator.openMenu()
    }
    
    func goToShareHandler(for shareable: Shareable) {
        defaultCoordinator.goToShareHandler(for: shareable)
    }
    
    func goToPDF(with data: Data) {
        defaultCoordinator.goToPDF(with: data)
    }
    
    func open(url: String) {
        defaultCoordinator.open(url: url)
    }
    
    func goToSavingCustomOption(with savings: Savings, option: SavingProductOptionRepresentable) {
        defaultCoordinator.goToSavingCustomOption(with: savings, option: option)
    }

    func goToMoreOperatives(_ savingProduct: SavingProductRepresentable) {
        defaultCoordinator.goToMoreOperatives(savingProduct)
    }

    func goToSendMoney(with option: SavingProductOptionRepresentable) {
        defaultCoordinator.goToSendMoney(with: option)
    }
}

private extension PLCustomSavingsHomeCoordinator {
    func linkHandlerFor(productId: String) -> PLWebviewCustomLinkHandler? {
        let manager: BSANManagersProvider = dependencies.resolve()
        guard let bsanEnvironment = try? manager.getBsanEnvironmentsManager().getCurrentEnvironment().getResponseData() else { return nil }
        guard let url = URL(string: bsanEnvironment.urlBase),
              let domain = url.host else { return nil }
        let finalUrl = String(format: PLGoalsWebViewConfiguration.urlFormat, domain, productId)
        let plLinkHandler = PLWebviewCustomLinkHandler(configuration: PLGoalsWebViewConfiguration(initialURL: finalUrl))
        return plLinkHandler
    }
}
