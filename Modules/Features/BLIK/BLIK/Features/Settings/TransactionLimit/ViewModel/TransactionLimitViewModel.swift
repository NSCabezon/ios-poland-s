struct TransactionLimitViewModel {
    let withdrawLimitValue: String
    let purchaseLimitValue: String
    let limitCurrency: String
    let chequqBlikLimitValue: String
    let withdrawLimitText: String
    let purchaseLimitText: String
    
    init(withdrawLimitValue: String, purchaseLimitValue: String, limitCurrency: String, chequqBlikLimitValue: String, withdrawLimitText: String, purchaseLimitText: String) {
        self.withdrawLimitValue = withdrawLimitValue
        self.purchaseLimitValue = purchaseLimitValue
        self.limitCurrency = limitCurrency
        self.chequqBlikLimitValue = chequqBlikLimitValue
        self.withdrawLimitText = withdrawLimitText
        self.purchaseLimitText = purchaseLimitText
    }
    
    init?(withdrawLimitValue: String, purchaseLimitValue: String) {
        self.withdrawLimitValue = withdrawLimitValue
        self.purchaseLimitValue = purchaseLimitValue
        limitCurrency = ""
        chequqBlikLimitValue = ""
        withdrawLimitText = ""
        purchaseLimitText = ""
    }
}
