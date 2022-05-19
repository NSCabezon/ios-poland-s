//
//  File.swift
//  Account
//
//  Created by 186484 on 25/04/2022.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: AuthorizationModuleCoordinator.self)
        let bundleURL = bundle.url(forResource: "Authorization", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
