//
//  Images.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/12/2021.
//

import Foundation

enum Images {
    enum Form {
        static var contactIcon: UIImage {
            return UIImage(fromModuleNamed: "contacts_icon")
        }
        
        static var rightChevronIcon: UIImage {
            return UIImage(fromModuleNamed: "right_chevron_icon")
        }
        
        static var tickIcon: UIImage {
            return UIImage(fromModuleNamed: "tick_icon")
        }
    }
}

private extension UIImage {
    convenience init(fromModuleNamed named: String) {
        self.init(named: named, in: .module, compatibleWith: nil)!
    }
}
