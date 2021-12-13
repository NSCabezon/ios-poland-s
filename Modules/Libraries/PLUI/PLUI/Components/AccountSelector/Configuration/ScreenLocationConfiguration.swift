import Foundation

extension AccountSelectorViewController {
    
    public enum ScreenLocationConfiguration {
        case mobileTransferSettings, mobileTransfer, charityTransfer
        
        var title: String {
            switch self {
            case .mobileTransferSettings:
                #warning("should be changed")
                return "#Wybierz konto, z którego chcesz zrobić przelew:"
            case .mobileTransfer:
                return "#Wybierz konto, z którego chcesz zrobić przelew:"
            case .charityTransfer:
                #warning("should be changed")
                return "#Wybierz konto, z którego chcesz zrobić przelew:"
            }
        }
        
        var showRightNavigationAction: Bool {
            self == .mobileTransfer
        }
    }
    
}
