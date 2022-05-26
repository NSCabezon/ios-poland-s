import UIKit

public struct PLQuickBalanceSelectableViewModel {
    public let leftTextKey: String
    public let rightTextKey: String
    public let status: Status
    
    public init(leftTextKey: String,
                rightTextKey: String,
                status: Status) {
        self.leftTextKey = leftTextKey
        self.rightTextKey = rightTextKey
        self.status = status
    }
    
    public enum Status {
        case activated
        case inactive
    }
}

public extension PLQuickBalanceSelectableViewModel.Status {
    var borderWidth: CGFloat {
        switch self {
        case .inactive:
            return 1.0
        case .activated:
            return .zero
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .inactive:
            return .white
        case .activated:
            return UIColor.oneTurquoise.withAlphaComponent(0.07)
        }
    }

    var titleTextColor: UIColor {
        switch self {
        case .inactive:
            return UIColor.oneLisboaGray
        case .activated:
            return UIColor.oneDarkTurquoise
        }
    }
    
    var titleTextFont: UIFont {
        switch self {
        case .inactive:
            return .santander(family: .headline, type: .bold, size: 18)
        case .activated:
            return .santander(family: .headline, type: .bold, size: 18)
        }
    }
    
    
    var subtitleTextFont: UIFont {
        switch self {
        case .inactive:
            return .santander(family: .micro, type: .regular, size: 14)
        case .activated:
            return .santander(family: .micro, type: .regular, size: 14)
        }
    }
}
