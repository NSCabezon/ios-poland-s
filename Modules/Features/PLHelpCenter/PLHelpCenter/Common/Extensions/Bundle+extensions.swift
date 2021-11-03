//
//  Bundle+extensions.swift
//  PLHelpCenter
//
//  Created by 186484 on 06/08/2021.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: PLHelpCenterModuleCoordinator.self)
        let bundleURL = bundle.url(forResource: "PLHelpCenter", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
