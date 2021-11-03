import Foundation

public struct CancelBLIKTransactionRequestDTO: Codable {
    let transactionDate: String
    let confirmFlag: ConfirmFlag
    
    public enum ConfirmFlag: String, Codable {
        case reject = "REJECTED"
        case timeout = "TIMEOUT"
    }

    public init(transactionDate: String, confirmFlag: ConfirmFlag) {
        self.transactionDate = transactionDate
        self.confirmFlag = confirmFlag
    }
}
