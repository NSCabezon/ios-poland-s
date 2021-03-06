//
//  PLWebViewCoordinatorNavigator.swift
//  Santander

import PLLogin
import CoreFoundationLib
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
    private lazy var sessionManager: CoreSessionManager = {
        return self.dependencies.resolve(for: CoreSessionManager.self)
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
        self.sessionManager.finishWithReason(.logOut)
        self.navigationController?.popToRootViewController(animated: true)
        if UIApplication.shared.canOpen(url: url) {
            UIApplication.shared.open(url: url)
        }
    }
}
