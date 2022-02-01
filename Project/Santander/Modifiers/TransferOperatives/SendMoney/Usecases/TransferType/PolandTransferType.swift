import TransferOperatives
import SANLegacyLibrary
import SANPLLibrary
import CoreDomain
import CoreFoundationLib

enum PolandTransferType: SendMoneyTransferTypeProtocol {
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
    
    var serviceString: String {
        switch self {
        case .zero:
            return "INTERNAL"
        case .one:
            return "ELIXIR"
        case .four:
            return "SWIFT"
        case .eight:
            return "EXPRESS_ELIXIR"
        case .a:
            return "BLUECASH"
        }
    }
    
    var asFinalFeeInputParameter: String {
        switch self {
        case .zero, .four:
            return ""
        case .one:
            return TransferFeeServiceIdDTO.elixir.rawValue
        case .eight:
            return TransferFeeServiceIdDTO.expressElixir.rawValue
        case .a:
            return TransferFeeServiceIdDTO.bluecash.rawValue
        }
    }
}
