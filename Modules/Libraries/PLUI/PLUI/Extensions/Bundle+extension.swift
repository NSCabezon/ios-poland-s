//
//  File.swift
//  PLUI
//
//  Created by Juan Sánchez Marín on 1/7/21.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let podBundle = Bundle(for: PLUIInputCodeView.self)
        let bundleURL = podBundle.url(forResource: "PLUI", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
