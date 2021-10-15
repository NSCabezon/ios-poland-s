import UIKit

extension UIColor {
    @nonobjc public class var greyBlue: UIColor {
        return UIColor(red: 103.0 / 255.0, green: 157.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
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
