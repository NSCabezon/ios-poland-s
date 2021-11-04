import SANPLLibrary

enum PolandTransactionType {
    case thirty
    case eight
    case ten
    case twelve
    case thirteen
    case fiftyThree
    case fiftyTwo
    case one
    case two
    
    init(dto: MatrixTransactionTypeDTO) {
        switch dto {
        case .thirty:
            self = .thirty
        case .eight:
            self = .eight
        case .ten:
            self = .ten
        case .twelve:
            self = .twelve
        case .thirteen:
            self = .thirteen
        case .fiftyThree:
            self = .fiftyThree
        case .fiftyTwo:
            self = .fiftyTwo
        case .one:
            self = .one
        case .two:
            self = .two
        }
    }
    
    var asDto: MatrixTransactionTypeDTO {
        switch self {
        case .thirty:
            return .thirty
        case .eight:
            return .eight
        case .ten:
            return .ten
        case .twelve:
            return .twelve
        case .thirteen:
            return .thirteen
        case .fiftyThree:
            return .fiftyThree
        case .fiftyTwo:
            return .fiftyTwo
        case .one:
            return .one
        case .two:
            return .two
        }
    }
}
