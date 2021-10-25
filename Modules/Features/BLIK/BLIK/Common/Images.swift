//
//  Images.swift
//  BLIK
//
//  Created by 186492 on 07/06/2021.
//

import Foundation

enum Images {
    static var copy: UIImage {
        UIImage(fromModuleNamed: "copy")
    }
    static var chevron: UIImage {
        UIImage(fromModuleNamed: "chevron")
    }
    static var ok: UIImage {
        UIImage(fromModuleNamed: "ok")
    }
    static var options: UIImage {
        UIImage(fromModuleNamed: "options")
    }
    static var error: UIImage {
        UIImage(fromModuleNamed: "error")
    }
    static var info: UIImage {
        UIImage(fromModuleNamed: "info")
    }
    static var info_lisboaGray: UIImage {
        UIImage(fromModuleNamed: "info_lisboaGray")
    }
    
    static var info_blueGreen: UIImage {
        UIImage(fromModuleNamed: "info_blueGreen")
    }
}

extension Images {
    enum Menu {
        static var mobileTransfer: UIImage {
            UIImage(fromModuleNamed: "mobileTransfer")
        }
        static var cheque: UIImage {
            UIImage(fromModuleNamed: "cheque")
        }
        static var alias: UIImage {
            UIImage(fromModuleNamed: "alias")
        }
        static var settings: UIImage {
            UIImage(fromModuleNamed: "settings")
        }
    }
    
    enum Cheques {
        static var emptyListBackground: UIImage {
            UIImage(fromModuleNamed: "emptyListMessageBackground")
        }
    }
    
    enum Settings {
        static var aliasPayment: UIImage {
            UIImage(fromModuleNamed: "aliasPayment")
        }
        static var phoneTransfer: UIImage {
            UIImage(fromModuleNamed: "phoneTransfer")
        }
        static var transferLimits: UIImage {
            UIImage(fromModuleNamed: "transferLimits")
        }
        static var otherSettings: UIImage {
            UIImage(fromModuleNamed: "otherSettings")
        }
        static var securityLock: UIImage {
            UIImage(fromModuleNamed: "securityLock")
        }
    }
    
    enum MobileTransfer {
        static var calendar: UIImage {
            UIImage(fromModuleNamed: "calendar")
        }
        static var contacts: UIImage {
            UIImage(fromModuleNamed: "contacts")
        }
    }
}

private extension UIImage {
    convenience init(fromModuleNamed named: String) {
        self.init(named: named, in: .module, compatibleWith: nil)!
    }
}
