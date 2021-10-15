//
//  Bundle+extension.swift
//  CreditCardRepayment
//
//  Created by 186484 on 08/06/2021.
//

import Foundation

extension Bundle {
    static let module: Bundle? = {
        let bundle = Bundle(for: CreditCardRepaymentModuleCoordinator.self)
        let bundleURL = bundle.url(forResource: "CreditCardRepayment", withExtension: "bundle")
        return bundleURL.flatMap(Bundle.init)
    }()
}
