import Foundation

import UIKit

public extension UIColor {
    @nonobjc class var greyishBrown: UIColor {
        UIColor(red: 65.0 / 255.0, green: 65.0 / 255.0, blue: 65.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var greyBlue: UIColor {
        UIColor(red: 103.0 / 255.0, green: 157.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleGreyTwo: UIColor {
        UIColor(red: 233.0 / 255.0, green: 223.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var suvaGrey: UIColor {
        UIColor(white: 139.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var pattensBlue: UIColor {
        UIColor(red: 233.0 / 255.0, green: 243.0 / 255.0, blue: 247 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var raven: UIColor {
        UIColor(red: 109.0 / 255.0, green: 114.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
    }
    
}

extension UIColor {
    public static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

