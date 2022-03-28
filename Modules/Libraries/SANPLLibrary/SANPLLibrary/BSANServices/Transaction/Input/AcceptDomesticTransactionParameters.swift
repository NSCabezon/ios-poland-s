import Foundation

public struct AcceptDomesticTransactionParameters: Encodable {
    
    let title: String
    let type: TransactionType
    let transferType: TransferType
    let signData: SignData?
    let valueDate: String
    let dstPhoneNo: String?

    let debitAmountData: AmountData
    let debitAccountData: DebitAccountData
    let creditAccountData: CreditAccountData
    let creditAmountData: AmountData?
    
    public init(title: String,
                type: TransactionType,
                transferType: TransferType,
                signData: SignData? = nil,
                dstPhoneNo: String? = nil,
                valueDate: String,
                debitAmountData: AmountData,
                debitAccountData: DebitAccountData,
                creditAccountData: CreditAccountData,
                creditAmountData: AmountData? = nil
    ) {
        self.title = title
        self.type = type
        self.transferType = transferType
        self.signData = signData
        self.valueDate = valueDate
        self.debitAmountData = debitAmountData
        self.debitAccountData = debitAccountData
        self.creditAccountData = creditAccountData
        self.dstPhoneNo = dstPhoneNo
        self.creditAmountData = creditAmountData
    }
    
}

public extension AcceptDomesticTransactionParameters {
    
    struct SignData: Encodable {
        let securityLevel: Int
        
        public init(securityLevel: Int) {
            self.securityLevel = securityLevel
        }
    }
    
    struct AmountData: Encodable {
        let amount: Decimal
        let currency: String
        
        public init(amount: Decimal, currency: String) {
            self.amount = amount
            self.currency = currency
        }
    }
    
    struct DebitAccountData: Encodable {
        let accountType: Int
        let accountSequenceNumber: Int
        let accountNo: String
        let accountName: String?
        
        public init(accountType: Int, accountSequenceNumber: Int, accountNo: String, accountName: String? = nil) {
            self.accountType = accountType
            self.accountSequenceNumber = accountSequenceNumber
            self.accountNo = accountNo
            self.accountName = accountName
        }
    }
    
    struct CreditAccountData: Encodable {
        let accountType: Int
        let accountSequenceNumber: Int
        let accountNo: String
        let accountName: String?

        public init(accountType: Int, accountSequenceNumber: Int, accountNo: String, accountName: String? = nil) {
            self.accountType = accountType
            self.accountSequenceNumber = accountSequenceNumber
            self.accountNo = accountNo
            self.accountName = accountName
        }
    }
    
    enum TransferType: String, Codable {
        case INTERNAL, ELIXIR, CELIXIR, SYBIR, SWIFT, ZUS, SORBNET, US, EXPRESS_ELIXIR, WESTERN_UNION, BLUECASH, BLIK_P2P
    }
    
    enum TransactionType: String, Codable {
        case OWN_TRANSACTION
        case TO_DEFINED_TRANSCTION
        case ZUS_TRANSACTION
        case LOAN_REPEYMENT
        case DEPOSIT_OPENING
        case DEPOSIT_CLOSING
        case LOAN_REVOLWING_WA_ACTIVATION
        case MULTICURRENCY_BZWBK_TRANSACTION
        case LOAN_REVOLWING_ACTIVATION
        case TWO_CURRENCY_TRANSCTION
        case DIRECT_DEBIT_PAYMENT
        case SWIFT_TRANSACTION
        case OWN_CURRENCY_TRANSACTION
        case TAX_TRANSACTION
        case TAX_TOKEN_TRANSACTION
        case MOBILE_TRANSACTION
        case MCOMMERCE_TRANSACTION
        case WESTERN_UNION_TRANSFER
        case PAYROLL_TRANSFER
        case ONLINE_SHOP_TOKEN_TRANSACTION
        case ONLINE_SHOP_TRANSACTION
        case LOAN_REPAYMENT_WA
        case DEPOSIT_ACTIVATION_WA
        case DEPOSIT_CLOSING_WA
        case SMS_PREPAID
        case INTERNET_PREPAID
        case INVESTMENT_FUNDS
        case OWN_TRANSACTION_WA
        case OWN_CURRENCY_TRANSACTION_WA
        case DEFAULT_TRANSACTION
        case ZUS_TOKEN_TRANSACTION
        case TRANSACTION_3D
        case BLIK_P2P_TRANSACTION
        case PREPAID_MOBILE_TRANSACTION
        case ONEAPP_PREPAID_MOBILE_TRANSACTION
        case SWIFT_PIN_TRANSCTION
        case PAYROLL_PIN_TRANSFER
        case MULTICURRENCY_BZWBK_PIN_TRANSACTION
        case THIRD_PARTY_BANKS_TRANSFER
        case THIRD_PARTY_BANKS_PIN_TRANSFER
        case MIFID_OPENING_TRANSFER
        case MIFID_TRANSFER
        case SPLIT_PAYMENT_TRANSACTION
        case OWN_SPLIT_PAYMENT_TRANSACTION
        case TO_DEFINED_SPLIT_PAYMENT_TRANSACTION
        case PRZELEW24_BLIK_TRANSACTION
        case SPLIT_PAYMENT_MOBILE_TRANSACTION
        case DEPOSIT_SURCHARGE
        case DIRECT_DEBIT_SPLIT_PAYMENT_TRANSACTION
        case PIS_TRANSACTION
        case MULTICURRENCY_SANTANDER_MOBILE_TRANSACTION
        case SWIFT_MOBILE_TRANSACTION
        case PLN_FROM_CURRENCY_ACCOUNT_TRANSACTION
        case PLN_FROM_CURRENCY_ACCOUNT_TOKEN_TRANSACTION
        case PAYHUB_TRANSCTION
        case BLIK_P2PR_TRANSACTION
        case ONEAPP_ZUS_TRANSACTION
        case ONEAPP_MOBILE_TRANSACTION
        case ONEAPP_BLIK_P2P_TRANSACTION
    }
    
}
