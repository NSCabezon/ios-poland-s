
protocol TransactionsLimitValidation {
    func validate(oldModel: TransactionLimitModel, newModel: TransactionLimitModel) -> TransactionsLimitValidationResult
}

final class TransactionsLimitValidator : TransactionsLimitValidation {
    func validate(oldModel: TransactionLimitModel, newModel: TransactionLimitModel) -> TransactionsLimitValidationResult {
        if newModel.purchaseLimit == 0 || newModel.withdrawLimit == 0 {
            return .invalid(.limitsNotGreaterThanZero)
        }
        
        if newModel.purchaseLimit > oldModel.purchaseLimit || newModel.withdrawLimit > oldModel.withdrawLimit {
            return .valid(.limitIncreaseNotice)
        }
        
        if newModel.purchaseLimit < oldModel.purchaseLimit || newModel.withdrawLimit < oldModel.withdrawLimit {
            return .invalid(.illegalLimitDecrease)
        }
        
        if newModel.purchaseLimit == oldModel.purchaseLimit && newModel.withdrawLimit == oldModel.withdrawLimit {
            return .valid(.limitsDidNotChange)
        }
    
        return .valid(.none)
    }
}
