import Foundation

public struct ErrorDTO: Codable {
    public let errorCode1: ErrorCode1
    public let errorCode2: ErrorCode2
    public let message: String?
    
    public enum ErrorCode1: Int, Codable {
        case customerTypeDisabled = 11
    }
    
    public enum ErrorCode2: Int, Codable {
        case pw_limit_exceeded = 17
        case pw_to_big_amount = 43
        case pw_account_blacklist = 99
        case pw_expr_recipient_inactive = 170
        case trnLimitExceeded = 709
        case cycleLimitExceeded = 710
        case errPosting = 711
        case insufficientFunds = 725
        case noTrnToConf = 728
        case p2pAliasNotExsist = 764
        case internalBranchAccountNoExist = 103
        case externalBranchBranchNoExist = 105
        
        public var errorKey: String {
            switch self {
            case .trnLimitExceeded:
                return "pl_blik_alert_text_amountLimit"
            case .cycleLimitExceeded:
                return "pl_blik_alert_text_dayLimit"
            case .errPosting:
                return "pl_blik_alert_text_tryLater"
            case .insufficientFunds:
                return "pl_blik_alert_text_noFunds"
            case .pw_limit_exceeded, .pw_to_big_amount:
                return "#Wpisana kwota jest wyższa niż dostępny limit przelewów w aplikacji."
            case .pw_account_blacklist:
                return "#Sprawdź poprawność wprowadzonego numeru rachunku. Przelew na wskazany rachunek może być zrealizowany wyłącznie w Oddziale Banku."
            case .pw_expr_recipient_inactive:
                return "#Bank odbiorcy nie obsługuje tego typu przelewów."
            default:
                return "pl_blik_alert_text_error"
            }
        }
    }
    
}
