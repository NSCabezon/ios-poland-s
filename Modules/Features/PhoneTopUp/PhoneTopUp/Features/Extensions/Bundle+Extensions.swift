//
//  Bundle+Extensions.swift
//  PhoneTopUp
//
//  Created by 188216 on 30/11/2021.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: PhoneTopUpFormCoordinator.self)
        let bundleURL = bundle.url(forResource: "PhoneTopUp", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
