public struct GenericSendMoneyConfirmationInput: Codable {
    let customerAddressData: CustomerAddressDataParameters?
    let debitAmountData: ItAmountDataParameters?
    let creditAmountData: ItAmountDataParameters?
    let debitAccountData: ItAccountDataParameters?
    let creditAccountData: ItAccountDataParameters?
    let signData: SignDataParameters?
    let title: String?
    let type: String?
    let transferType: String?
    let valueDate: String?
    
    public init(customerAddressData: CustomerAddressDataParameters?, debitAmountData: ItAmountDataParameters?, creditAmountData: ItAmountDataParameters?, debitAccountData: ItAccountDataParameters?, creditAccountData: ItAccountDataParameters?, signData: SignDataParameters?, title: String?, type: String?, transferType: String?, valueDate: String?) {
        self.customerAddressData = customerAddressData
        self.debitAmountData = debitAmountData
        self.creditAmountData = creditAmountData
        self.debitAccountData = debitAccountData
        self.creditAccountData = creditAccountData
        self.signData = signData
        self.title = title
        self.type = type
        self.transferType = transferType
        self.valueDate = valueDate
    }
}

public struct CustomerAddressDataParameters: Codable {
    public init(customerName: String?, city: String?, street: String?, zipCode: String?, baseAddress: String?) {
        self.customerName = customerName
        self.city = city
        self.street = street
        self.zipCode = zipCode
        self.baseAddress = baseAddress
    }
    
    let customerName: String?
    let city: String?
    let street: String?
    let zipCode: String?
    let baseAddress: String?
}

// MARK: - ItAccountData
public struct ItAccountDataParameters: Codable {
    public init(accountNo: String?, accountName: String?, sequenceNumber: Int? = nil, accountSequenceNumber: Int? = nil, accountType: Int?) {
        self.accountNo = accountNo
        self.accountName = accountName
        self.sequenceNumber = sequenceNumber
        self.accountType = accountType
        self.accountSequenceNumber = accountSequenceNumber
    }
    
    let accountNo: String?
    let accountName: String?
    let sequenceNumber: Int?
    let accountType: Int?
    let accountSequenceNumber: Int?
}

// MARK: - ItAmountData
public struct ItAmountDataParameters: Codable {
    public init(currency: String?, amount: Decimal?) {
        self.currency = currency
        self.amount = amount
    }
    
    let currency: String?
    let amount: Decimal?

}

// MARK: - SignData
public struct SignDataParameters: Codable {
    public init(securityLevel: Int?) {
        self.securityLevel = securityLevel
    }
    
    let securityLevel: Int?
}
