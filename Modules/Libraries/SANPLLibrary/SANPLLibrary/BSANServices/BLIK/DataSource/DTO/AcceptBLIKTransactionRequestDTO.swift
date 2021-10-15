import Foundation

public struct AcceptBLIKTransactionRequestDTO: Codable {
    let transactionDate: String
    let confirmFlag: String

    public init(transactionDate: String) {
        self.transactionDate = transactionDate
        self.confirmFlag = "ACCEPTED"
    }
}
