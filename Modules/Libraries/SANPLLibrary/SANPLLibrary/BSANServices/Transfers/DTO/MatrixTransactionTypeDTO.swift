public enum MatrixTransactionTypeDTO: String, Codable {
    case thirty = "DEFAULT_TRANSACTION"
    case eight = "MULTICURRENCY_INTERNAL_TRANSACTION"
    case ten = "TWO_CURRENCY_TRANSACTION"
    case twelve = "SWIFT_TRANSACTION"
    case thirteen = "OWN_CURRENCY_TRANSACTION"
    case fiftyThree = "PLN_FROM_CURRENCY_ACCOUNT_TOKEN_TRANSACTION"
    case fiftyTwo = "PLN_FROM_CURRENCY_ACCOUNT_TRANSACTION"
    case one = "OWN_TRANSACTION"
    case two = "TO_DEFINED_TRANSACTION"
}
