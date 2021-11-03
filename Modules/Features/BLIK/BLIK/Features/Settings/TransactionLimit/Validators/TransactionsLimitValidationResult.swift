enum TransactionsLimitValidationResult {
    case valid(ValidityOption)
    case invalid(InvalidityReason)
}

enum ValidityOption {
    case none
    case limitIncreaseNotice
    case limitsDidNotChange
}


enum InvalidityReason {
    case illegalLimitDecrease
    case limitsNotGreaterThanZero
}
