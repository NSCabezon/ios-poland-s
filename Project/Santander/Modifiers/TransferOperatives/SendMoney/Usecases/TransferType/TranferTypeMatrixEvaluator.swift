struct TranferTypeMatrixEvaluator: Hashable {
    enum MatrixTransferType {
        case zero
        case one
        case oneWithOptional
        case four
        case eight
        case a
        
        var toTransferType: PolandTransferType {
            switch self {
            case .zero: return .zero
            case .one: return .one
            case .oneWithOptional: return .one
            case .four: return .four
            case .eight: return .eight
            case .a: return .a
            }
        }
    }
    
    private let isSourceCurrencyPLN: Bool
    private let isDestinationAccountInternal: Bool
    private let isDestinationAccountCurrencyPLN: Bool
    private let isOwner: Bool
    private let isCountryPLN: Bool
    private let isAccountTrusted: Bool
    
    init(
        isSourceCurrencyPLN: Bool,
        isDestinationAccountInternal: Bool,
        isDestinationAccountCurrencyPLN: Bool,
        isOwner: Bool,
        isCountryPLN: Bool,
        isAccountTrusted: Bool = false
    ) {
        self.isSourceCurrencyPLN = isSourceCurrencyPLN
        self.isDestinationAccountInternal = isDestinationAccountInternal
        self.isDestinationAccountCurrencyPLN = isDestinationAccountCurrencyPLN
        self.isOwner = isOwner
        self.isCountryPLN = isCountryPLN
        self.isAccountTrusted = isAccountTrusted
    }
    
    var transferTypes: [TranferTypeMatrixEvaluator: MatrixTransferType] {
        return [
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .oneWithOptional,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .oneWithOptional,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .one,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .one,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: false, isAccountTrusted: false): .four,
            // TODO: It has the same conditions as other one, checking with bank
            // TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .one,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: false, isAccountTrusted: false): .four,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .zero,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .zero
        ]
    }
    
    var transactionTypes: [TranferTypeMatrixEvaluator: PolandTransactionType] {
        return [
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .sixtyThree,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .sixtyThree,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .fiftyNine,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .fiftyNine,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .fiftyEight,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .seventyOne,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .seventyOne,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .seventyOne,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .seventyThree,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .seventySix,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .seventyOne,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: false, isAccountTrusted: false): .seventyTwo,
            // TODO: It has the same conditions as other one, checking with bank
            // TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .seventySix,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: false, isAccountTrusted: false): .seventyTwo,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .sixtyOne,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .sixtyOne,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .sixtyOne
        ]
    }

    func evaluateTransferType() -> MatrixTransferType? {
        return transferTypes[self]
    }
    
    func evaluateTransactionType() -> PolandTransactionType? {
        return transactionTypes[self]
    }
}
