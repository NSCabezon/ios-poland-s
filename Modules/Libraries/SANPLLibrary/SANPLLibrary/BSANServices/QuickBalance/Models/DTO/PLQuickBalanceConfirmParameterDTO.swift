public struct PLQuickBalanceConfirmParameterDTO: Codable {
    public let accountNo: String
    public let amount: Double?

    public init(accountNo: String,
                amount: Double?) {
        self.accountNo = accountNo
        self.amount = amount
    }
}
