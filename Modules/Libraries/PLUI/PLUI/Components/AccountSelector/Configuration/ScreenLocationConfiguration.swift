import Foundation
import Commons

extension AccountSelectorViewController {
    
    public enum ScreenLocationConfiguration {
        case mobileTransferSettings, mobileTransfer, charityTransfer, phoneTopUp, zusTransfer
        
        var title: String {
            switch self {
            case .mobileTransferSettings:
                #warning("should be changed")
                return "#Wybierz konto, z którego chcesz zrobić przelew:"
            case .mobileTransfer:
                return localized("pl_blik_text_infoSelectAccountForSend")
            case .charityTransfer:
                return localized("pl_foundtrans_text_infoSelectAccount")
            case .zusTransfer:
                #warning("should be changed")
                return "#Wybierz konto, z którego chcesz zrobić przelew:"
            case .phoneTopUp:
                #warning("should be changed")
                return "#Wybierz konto, z którego chcesz doładować telefon:"
            }
        }
        
        var showRightNavigationAction: Bool {
            self == .mobileTransfer || self == .charityTransfer || self == .zusTransfer
        }
    }
    
}
