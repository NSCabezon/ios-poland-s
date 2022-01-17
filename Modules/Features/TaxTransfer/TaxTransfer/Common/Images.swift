//
//  Images.swift
//  TaxTransfer
//
//  Created by 185167 on 21/12/2021.
//

enum Images {
    enum Common {
        static var chevron: UIImage {
            return UIImage(fromModuleNamed: "chevron")
        }
    }
}

private extension UIImage {
    convenience init(fromModuleNamed named: String) {
        self.init(named: named, in: .module, compatibleWith: nil)!
    }
}
