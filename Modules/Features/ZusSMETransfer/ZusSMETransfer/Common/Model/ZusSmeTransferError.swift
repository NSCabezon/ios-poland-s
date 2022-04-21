import SANPLLibrary

struct ZusSmeTransferError {
    let errorCode1: ErrorCode1
    let errorCode2: ErrorCode2
    
    enum ErrorCode1: Int, Codable {
        case customerTypeDisabled = 11
        case unknown = -1
    }
    
    enum ErrorCode2: Int, Codable {
        case pw_limit_exceeded = 17
        case pw_to_big_amount = 43
        case pw_account_blacklist = 99
        case pw_expr_recipient_inactive = 170
        case unknown = -1
    }
    
    init?(with dto: PLErrorDTO?) {
        guard let dto = dto else { return nil }
        errorCode1 = ErrorCode1(rawValue: dto.errorCode1) ?? .unknown
        errorCode2 = ErrorCode2(rawValue: dto.errorCode2) ?? .unknown
    }
    
    var errorResult: AcceptZusSmeTransactionErrorResult {
        guard errorCode1 == .customerTypeDisabled else {
            return .generalErrorMessages
        }
        switch errorCode2 {
        case .pw_limit_exceeded, .pw_to_big_amount:
            return .limitExceeded
        case .pw_account_blacklist:
            return .accountOnBlacklist
        case .pw_expr_recipient_inactive:
            return .expressEecipientInactive
        case .unknown:
            return .generalErrorMessages
        }
    }
}
