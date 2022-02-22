public enum MatrixTransactionTypeDTO: String, Codable {
    case sixtyThree = "DEFAULT_TRANSACTION"
    case seventyOne = "MULTICURRENCY_INTERNAL_TRANSACTION"
    case ten = "TWO_CURRENCY_TRANSACTION"
    case seventyTwo = "SWIFT_TRANSACTION"
    case sixtyOne = "OWN_CURRENCY_TRANSACTION"
    case seventyThree = "PLN_FROM_CURRENCY_ACCOUNT_TOKEN_TRANSACTION"
    case seventySix = "PLN_FROM_CURRENCY_ACCOUNT_TRANSACTION"
    case fiftyEight = "OWN_TRANSACTION"
    case fiftyNine = "TO_DEFINED_TRANSACTION"
}
