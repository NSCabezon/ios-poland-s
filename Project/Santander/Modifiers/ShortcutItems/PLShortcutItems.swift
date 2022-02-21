//
//  PLShortcutItems.swift
//  Santander
//

import CoreFoundationLib
import UIKit

final class PLShortcutItems {
    private struct ShortcutItem: ShortcutItemProtocol {
        let localizedTitleKey: String
        let icon: UIApplicationShortcutIcon
        let deepLink: DeepLinkEnumerationCapable
    }

    private lazy var blik: ShortcutItem = {
        let blikIcon = UIApplicationShortcutIcon(templateImageName: "icnBlikBlack")
        return ShortcutItem(localizedTitleKey: "pl_widget_button_blik", icon: blikIcon, deepLink: PolandDeepLink.blik)
    }()

    private lazy var services: ShortcutItem = {
        let servicesIcon = UIApplicationShortcutIcon(templateImageName: "icnMcommerce")
        return ShortcutItem(localizedTitleKey: "pl_widget_button_services", icon: servicesIcon, deepLink: PolandDeepLink.services)
    }()

    private lazy var newTransfer: ShortcutItem = {
        let newTransferIcon = UIApplicationShortcutIcon(templateImageName: "icnSendMoney")
        return ShortcutItem(localizedTitleKey: "pl_widget_button_transfer", icon: newTransferIcon, deepLink: PolandDeepLink.sendMoney)
    }()
}

extension PLShortcutItems: ShortcutItemsProviderProtocol {
    func getShortcutItems() -> [ShortcutItemProtocol] {
        return [blik, services, newTransfer]
    }
}
