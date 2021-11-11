import TransferOperatives
import SANLegacyLibrary
import SANPLLibrary
import CoreDomain
import Commons
import Models

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
        switch self {
        case .eight: return TransferFeeServiceIdDTO.expressElixir.rawValue
        case .a: return TransferFeeServiceIdDTO.bluecash.rawValue
        default: return TransferFeeServiceIdDTO.elixir.rawValue
        }
    }
}