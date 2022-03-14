//
//  PLInboxActionBuilder.swift
//  Santander
//

import Foundation
import Inbox
import CoreFoundationLib
import UI
import PLCommons
import PLCommonOperatives

final class PLInboxActionBuilder {
    private var inboxActions: [InboxActionViewModel] = []
    private weak var delegate: InboxActionDelegate?
    private var isWebViewConfiguration: Bool?
    private let resolver: DependenciesResolver

    init(resolver: DependenciesResolver) {
        self.resolver = resolver
    }
}

extension PLInboxActionBuilder: InboxActionBuilderProtocol {
    func addInboxActionViewModel(offerOnLine: OfferEntity?) -> [InboxActionViewModel] {
        self.addOnlineInbox(offerOnLine)
        self.addInboxSetup(offerOnLine)
        return self.inboxActions
    }

    func webViewConfigurationEnabled(_ isWebViewConfiguration: Bool?) {
        self.isWebViewConfiguration = isWebViewConfiguration
    }

    func addDelegate(_ delegate: InboxActionDelegate) {
        self.delegate = delegate
    }

    func trackTapNotificationInbox(_ handler: @escaping () -> Void) {
        handler()
    }
}

private extension PLInboxActionBuilder {
    private func addOnlineInbox(_ offer: OfferEntity?) {
        let isWebViewConfiguration = self.isWebViewConfiguration ?? false
        let inboxActionExtras = isWebViewConfiguration ? InboxActionExtras(action: ()) : InboxActionExtras(offer: offer)
        let viewModel = InboxActionViewModel(
            imageName: "icnEmail",
            title: localized("mailbox_title_onlineMail"),
            description: localized("mailbox_text_onlineMail"),
            extras: inboxActionExtras,
            accessibilityIdentifier: AccesibilityInbox.messages,
            action: { _ in
                self.showToast()
            },
            offerAction: isWebViewConfiguration ? nil : self.delegate?.didSelectOffer
        )
        self.inboxActions.append(viewModel)
    }

    private func addPrivateBankStatement(_ offer: OfferEntity?) {
        let viewModel = InboxActionViewModel(
            imageName: "icnExcerpts",
            title: localized("mailbox_title_privateBankExcerpts"),
            description: localized("mailbox_text_privateBankExcerpts"),
            extras: InboxActionExtras(action: ()),
            accessibilityIdentifier: AccesibilityInbox.privateBankExcerpts,
            action: { _ in
                self.showToast()
            }
        )
        self.inboxActions.append(viewModel)
    }

    private func addInboxSetup(_ offer: OfferEntity?) {
        let viewModel = InboxActionViewModel(
            imageName: "icnNotification",
            title: localized("mailbox_title_notification"),
            description: localized("mailbox_text_notification"),
            notificationAlert: localized("mailbox_link_settingAlert"),
            extras: InboxActionExtras(offer: offer),
            accessibilityIdentifier: AccesibilityInbox.notifications,
            action: { [weak self] _ in
                self?.delegate?.gotoInboxNotification(nil)
            }, offerAction: { [weak self] _ in
                self?.goToAlerts24Webview()
            }
        )
        self.inboxActions.append(viewModel)
    }

    private func addContract(_ offer: OfferEntity?) {
        let viewModel = InboxActionViewModel(
            imageName: "icnContractMailbox",
            title: localized("mailbox_title_contractMailbox"),
            description: localized("mailbox_text_contractMailbox"),
            extras: InboxActionExtras(action: ()),
            accessibilityIdentifier: AccesibilityInbox.contract,
            action: { _ in
                self.showToast()
            }
        )
        self.inboxActions.append(viewModel)
    }

    private func showToast() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
    
    private func goToAlerts24Webview() {
        let repository = resolver.resolve(for: PLAccountOtherOperativesInfoRepository.self)

        guard let options = repository.get()?.accountsOptions,
              let option = options.first(where: { $0.id == PLAccountOperativeIdentifier.alerts24.rawValue }),
              option.isAvailable ?? true,
              let url = option.url,
              let method = option.method,
              let methodType = HTTPMethodType(rawValue: method)
        else {
            Toast.show(localized("generic_alert_notAvailableOperation"))
            return
        }

        let input = GetBasePLWebConfigurationUseCaseInput(initialURL: url, method: methodType, isFullScreenEnabled: option.isFullScreen)
        let webViewCoordinator = resolver.resolve(for: PLWebViewCoordinatorDelegate.self)
        let useCase = resolver.resolve(for: GetBasePLWebConfigurationUseCaseProtocol.self)
        
        Scenario(useCase: useCase, input: input)
            .execute(on: resolver.resolve())
            .onSuccess { result in
                let handler = PLWebviewCustomLinkHandler(configuration: result.configuration)
                webViewCoordinator.showWebView(handler: handler)
            }
            .onError { error in
                Toast.show(error.getErrorDesc() ?? "")
            }
    }
}
