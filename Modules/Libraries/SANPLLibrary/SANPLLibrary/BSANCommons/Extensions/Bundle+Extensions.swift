//
//  Bundle+Extensions.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: BSANLocalManager.self)
        guard let bundleName = bundle.bundleIdentifier?.split(".").last else { return nil }
        let bundleURL = bundle.url(forResource: bundleName, withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
