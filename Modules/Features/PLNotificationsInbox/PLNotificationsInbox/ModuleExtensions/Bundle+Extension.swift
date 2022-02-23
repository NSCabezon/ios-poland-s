//
//  Bundle+Extension.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 30/12/2021.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: PLNotificationsInboxModuleCoordinator.self)
        let bundleURL = bundle.url(forResource: "PLNotificationsInbox", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
