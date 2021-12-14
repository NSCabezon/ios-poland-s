import SANPLLibrary

struct BlikError {
    let errorCode1: ErrorCode1
    let errorCode2: ErrorCode2
    let message: String?
    
    enum ErrorCode1: Int, Codable {
        case customerTypeDisabled = 11
        case unknown = -1
    }
    
    enum ErrorCode2: Int, Codable {
        case pw_limit_exceeded = 17
        case pw_to_big_amount = 43
        case pw_account_blacklist = 99
        case pw_expr_recipient_inactive = 170
        case authCodeRequired = 702
        case trnLimitExceeded = 709
        case cycleLimitExceeded = 710
        case errPosting = 711
        case insufficientFunds = 725
        case noTrnToConf = 728
        case p2pAliasNotExsist = 764
        case unknown = -1
    }
    
    init?(with dto: PLErrorDTO?) {
        guard let dto = dto else { return nil }
        errorCode1 = ErrorCode1(rawValue: dto.errorCode1) ?? .unknown
        errorCode2 = ErrorCode2(rawValue: dto.errorCode2) ?? .unknown
        message = dto.message
    }
    
    var errorKey: String {
        switch errorCode2 {
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
