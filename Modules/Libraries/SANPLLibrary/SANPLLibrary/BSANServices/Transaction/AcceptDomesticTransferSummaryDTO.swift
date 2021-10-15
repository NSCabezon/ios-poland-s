import Foundation

public struct AcceptDomesticTransferSummaryDTO: Codable {
    
    public let title: String
    public let type: TransactionType
    public let state: TransactionState
    public let debitAmountData: AmountData
    public let debitAccountData: DebitAccountData
    public let creditAccountData: CreditAccountData
    public let dstPhoneNo: String?
    public let valueDate: String?

}

public extension AcceptDomesticTransferSummaryDTO {
    
    struct AmountData: Codable {
        public let currency: String?
        public let amount: Double?
    }
    
    struct DebitAccountData: Codable {
        public let accountType: Int?
        public let accountSequenceNumber: Int?
        public let accountNo: String?
        public let accountName: String?
    }
    
    struct CreditAccountData: Codable {
        public let accountType: Int?
        public let accountSequenceNumber: Int?
        public let accountNo: String?
        public let accountName: String?
    }
    
    enum TransactionState: String, Codable {
        case TRASH_BIN, MODIFIED_TRASH_BIN, EXTERNAL_ORDER, WAIT_ROOM, PARTIALLY_SIGNED, SIGNED, EXTERNAL_ORDER_POSTED, ACCEPTED, ACCEPTED_WITH_BLOCK, SENT, CANCELLED, POSTED, MEMO_POSTED, ERROR, ERROR_INSUFFICIENT_FUNDS, ERROR_CLOSED_ACCOUNT, ERROR_NO_ACCOUNT, ERROR_MANUAL_DENY, ERROR_OTHER_REASON, ERROR_NO_PRODUCT, ERROR_AGAINST_INSTRUCTION, ERROR_TO_SMALL_AMOUNT, ERROR_TO_BIG_AMOUNT, ERROR_BNF_BANK_REJECTED, ERROR_FRAUD, ERROR_OTHER, ERROR_BAD_CHECK_SUM, ERROR_CHECK_SUM
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
    }
    
}
