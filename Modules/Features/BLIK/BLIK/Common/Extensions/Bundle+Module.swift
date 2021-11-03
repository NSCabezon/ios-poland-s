//
//  Bundle+Module.swift
//  BLIK
//
//  Created by 186492 on 07/06/2021.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: BLIKHomeCoordinator.self)
        let bundleURL = bundle.url(forResource: "BLIK", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
