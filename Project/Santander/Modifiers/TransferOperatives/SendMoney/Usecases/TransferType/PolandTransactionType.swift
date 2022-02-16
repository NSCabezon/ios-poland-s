import SANPLLibrary

enum PolandTransactionType {
    case sixtyThree
    case seventyOne
    case ten
    case seventyTwo
    case sixtyOne
    case seventyThree
    case seventySix
    case fiftyEight
    case fiftyNine
    
    init(dto: MatrixTransactionTypeDTO) {
        switch dto {
        case .sixtyThree:
            self = .sixtyThree
        case .seventyOne:
            self = .seventyOne
        case .ten:
            self = .ten
        case .seventyTwo:
            self = .seventyTwo
        case .sixtyOne:
            self = .sixtyOne
        case .seventyThree:
            self = .seventyThree
        case .seventySix:
            self = .seventySix
        case .fiftyEight:
            self = .fiftyEight
        case .fiftyNine:
            self = .fiftyNine
        }
    }
    
    var asDto: MatrixTransactionTypeDTO {
        switch self {
        case .sixtyThree:
            return .sixtyThree
        case .seventyOne:
            return .seventyOne
        case .ten:
            return .ten
        case .seventyTwo:
            return .seventyTwo
        case .sixtyOne:
            return .sixtyOne
        case .seventyThree:
            return .seventyThree
        case .seventySix:
            return .seventySix
        case .fiftyEight:
            return .fiftyEight
        case .fiftyNine:
            return .fiftyNine
        }
    }
}
