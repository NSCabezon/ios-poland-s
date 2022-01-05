//
//  Bundle+Module.swift
//  TaxTransfer
//
//  Created by 185167 on 21/12/2021.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: TaxTransferFormCoordinator.self)
        let bundleURL = bundle.url(forResource: "TaxTransfer", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
