import Foundation

enum Images {
    enum Common {
        static var emptyImage: UIImage {
            return UIImage(fromModuleNamed: "imgLeaves")
        }
    }
}

private extension UIImage {
    convenience init(fromModuleNamed named: String) {
        self.init(named: named, in: .module, compatibleWith: nil)!
    }
}
