//
//  PLInboxActionBuilder.swift
//  Santander
//

import Foundation
import Inbox
import CoreFoundationLib
import CoreFoundationLib
import UI

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
        self.addInboxSetup()
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

    private func addInboxSetup() {
        let viewModel = InboxActionViewModel(
            imageName: "icnNotification",
            title: localized("mailbox_title_notification"),
            description: localized("mailbox_text_notification"),
            notificationAlert: localized("mailbox_link_settingAlert"),
            extras: InboxActionExtras(action: ()),
            accessibilityIdentifier: AccesibilityInbox.notifications,
            action: { _ in
                self.showToast()
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
}
