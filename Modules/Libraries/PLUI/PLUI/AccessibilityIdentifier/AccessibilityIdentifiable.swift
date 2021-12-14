import Foundation

public protocol AccessibilityIdentifiable {
    var id: String { get }
    var rawValue: String { get }
}

extension AccessibilityIdentifiable {
    public var id: String {
        let thisType = type(of: self)
        return String(describing: thisType) + "." + rawValue
    }
}
