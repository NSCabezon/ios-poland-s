//
//  Images.swift
//  ScanAndPay
//
//  Created by 188216 on 23/03/2022.
//

import Foundation
import PLUI

enum Images {
    enum Scanner {
        static var qrCodeImage: UIImage {
            return UIImage(fromModuleNamed: "qrCodeImage")
        }
    }
}

private extension UIImage {
    convenience init(fromModuleNamed named: String) {
        self.init(named: named, in: .module, compatibleWith: nil)!
    }
}
