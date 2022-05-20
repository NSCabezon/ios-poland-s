public struct PLQuickBalanceConfirmParameterDTO: Codable {
    public let accountNo: String
    public let amount: Int?

    public init(accountNo: String,
                amount: Int?) {
        self.accountNo = accountNo
        self.amount = amount
    }
}
