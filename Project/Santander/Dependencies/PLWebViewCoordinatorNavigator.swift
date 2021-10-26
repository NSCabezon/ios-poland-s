//
//  PLWebViewCoordinatorNavigator.swift
//  Santander

import PLLogin
import Commons
import UI
import RetailLegacy
import WebViews
import PLCommons

final class PLWebViewCoordinatorNavigator {

    private weak var drawer: BaseMenuViewController?
    private let dependencies: DependenciesDefault
    private weak var navigationController: UINavigationController?
    private lazy var baseWebViewNavigatableLauncher: BaseWebViewNavigatableLauncher = {
        return self.dependencies.resolve()
    }()
    private lazy var sessionController: SessionController = {
        return self.dependencies.resolve(for: SessionController.self)
    }()

    init(dependenciesResolver: DependenciesResolver, drawer: BaseMenuController) {
        self.drawer = drawer as? BaseMenuViewController
        self.dependencies = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = drawer.currentRootViewController as? UINavigationController
    }
}

extension PLWebViewCoordinatorNavigator: PLLoginWebViewCoordinatorDelegate, PLWebViewCoordinatorDelegate {
    func showWebView(handler: WebViewLinkHandler) {
        self.baseWebViewNavigatableLauncher.goToWebView(configuration: handler.configuration, linkHandler: handler, didCloseClosure: nil)
    }

    func closedWebView(url: URL) {
        self.sessionController.finishSession(.logOut)
        self.navigationController?.popToRootViewController(animated: true)
        if UIApplication.shared.canOpen(url: url) {
            UIApplication.shared.open(url: url)
        }
    }
}
