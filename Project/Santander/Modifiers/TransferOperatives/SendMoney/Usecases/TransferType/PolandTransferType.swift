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

extension PolandTransferType {
    var title: String? {
        switch self {
        case .one:
            return localized("sendMoney_label_standardSent")
        case .eight:
            return localized("sendMoney_label_immediateSend")
        case .a:
            return localized("sendMoney_label_expressDelivery")
        case .creditCardAccount:
            return localized("sendMoney_title_creditCardAccount")
        default:
            return nil
        }
    }
    
    var subtitle: String? {
        switch self {
        case .one:
            return localized("sendType_text_standar")
        case .eight:
            return localized("sendType_text_inmediate")
        case .a:
            return localized("sendType_text_express")
        case .creditCardAccount:
            return localized("sendMoney_text_creditCardAccount")
        default:
            return nil
        }
    }
    
    var limitAmount: AmountRepresentable {
        switch self {
        case .eight:
            return AmountDTO(value: Decimal(5000), currency: .create(.złoty))
        case .a:
            return AmountDTO(value: Decimal(20000), currency: .create(.złoty))
        default:
            return AmountDTO(value: .zero, currency: .create(.złoty))
        }
    }
}
