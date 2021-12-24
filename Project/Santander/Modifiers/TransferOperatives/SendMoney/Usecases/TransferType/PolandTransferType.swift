import TransferOperatives
import SANLegacyLibrary
import SANPLLibrary
import CoreDomain
import Commons
import CoreFoundationLib

enum PolandTransferType: SendMoneyTransferTypeProtocol {
    case creditCardAccount
    case zero
    case one
    case four
    case eight
    case a
    
    init(serviceId: TransferFeeServiceIdDTO) {
        switch serviceId {
        case .elixir:
            self = .one
        case .expressElixir:
            self = .eight
        case .bluecash:
            self = .a
        }
    }
    
    var asDto: MatrixTransferTypeDTO? {
        switch self {
        case .creditCardAccount:
            return nil
        case .zero:
            return .zero
        case .one:
            return .one
        case .four:
            return .four
        case .eight:
            return .eight
        case .a:
            return .a
        }
    }
    
    var serviceString: String {
        self.asDto?.rawValue ?? ""
    }
}
