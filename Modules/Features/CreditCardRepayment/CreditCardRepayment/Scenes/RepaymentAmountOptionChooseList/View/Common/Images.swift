//
//  Images.swift
//  CreditCardRepayment
//
//  Created by 186484 on 11/06/2021.
//

import Foundation

enum Images {
    static var radioBtnSelected: UIImage {
        UIImage(fromModuleNamed: "radioBtnSelected")
    }
    static var radioBtnUnselected: UIImage {
        UIImage(fromModuleNamed: "radioBtnUnselected")
    }
    static var penEdit: UIImage {
        UIImage(fromModuleNamed: "penEdit")
    }
}

private extension UIImage {
    convenience init(fromModuleNamed named: String) {
        self.init(named: named, in: .module, compatibleWith: nil)!
    }
}
