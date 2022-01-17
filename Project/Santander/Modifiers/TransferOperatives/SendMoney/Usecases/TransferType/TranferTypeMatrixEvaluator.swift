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
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .thirty,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .thirty,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .two,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .two,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .one,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .eight,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .eight,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .eight,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .fiftyThree,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .fiftyTwo,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: true, isAccountTrusted: false): .eight,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: false, isAccountTrusted: false): .twelve,
            // TODO: It has the same conditions as other one, checking with bank
            // TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: false, isCountryPLN: true, isAccountTrusted: true): .fiftyTwo,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: false, isDestinationAccountCurrencyPLN: false, isOwner: false, isCountryPLN: false, isAccountTrusted: false): .twelve,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .thirteen,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: false, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: true, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .thirteen,
            TranferTypeMatrixEvaluator(isSourceCurrencyPLN: true, isDestinationAccountInternal: true, isDestinationAccountCurrencyPLN: false, isOwner: true, isCountryPLN: true, isAccountTrusted: false): .thirteen
        ]
    }

    func evaluateTransferType() -> MatrixTransferType? {
        return transferTypes[self]
    }
    
    func evaluateTransactionType() -> PolandTransactionType? {
        return transactionTypes[self]
    }
}
