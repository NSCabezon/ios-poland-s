//
//  Bundle+extension.swift
//  PLContexts
//
//  Created by Ernesto Fernandez Calles on 23/12/21.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: ContextSelectorCoordinator.self)
        let bundleURL = bundle.url(forResource: "PLContexts", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
