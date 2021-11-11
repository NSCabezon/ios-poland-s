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
    
    public init(customerAddressData: CustomerAddressDataParameters?, debitAmountData: ItAmountDataParameters?, creditAmountData: ItAmountDataParameters?, debitAccountData: ItAccountDataParameters?, creditAccountData: ItAccountDataParameters?, signData: SignDataParameters?, title: String?, type: String?, transferType: String?) {
        self.customerAddressData = customerAddressData
        self.debitAmountData = debitAmountData
        self.creditAmountData = creditAmountData
        self.debitAccountData = debitAccountData
        self.creditAccountData = creditAccountData
        self.signData = signData
        self.title = title
        self.type = type
        self.transferType = transferType
    }
}

public struct CustomerAddressDataParameters: Codable {
    let customerName: String?
    let city: String?
    let street: String?
    let zipCode: String?
    let baseAddress: String?
}

// MARK: - ItAccountData
public struct ItAccountDataParameters: Codable {
    let accountNo: String?
    let accountName: String?
    let sequenceNumber: Int?
    let accountType: Int?
}

// MARK: - ItAmountData
public struct ItAmountDataParameters: Codable {
    let currency: String?
    let amount: Decimal?

}

// MARK: - SignData
public struct SignDataParameters: Codable {
    let securityLevel: Int?
}
