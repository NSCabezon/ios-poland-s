public struct BlikAcceptTransactionParameters {
    let trnId: Int
    let trnDate: String
    let transactionParameters: TransactionParameters?
    
    public init(
        trnId: Int,
        trnDate: String,
        transactionParameters: TransactionParameters?
    ) {
        self.trnId = trnId
        self.trnDate = trnDate
        self.transactionParameters = transactionParameters
    }
}

