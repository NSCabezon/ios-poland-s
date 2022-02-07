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

extension PolandTransferType {
    var title: String? {
        switch self {
        case .one:
            return "sendMoney_label_standardSent"
        case .eight:
            return "sendMoney_label_immediateSend"
        case .a:
            return "sendMoney_label_expressDelivery"
        case .zero:
            return "pl_confirmation_label_internalTransfer"
        case .four:
            return nil
        }
    }
    
    var subtitle: String? {
        switch self {
        case .one:
            return "sendType_text_standar"
        case .eight:
            return "sendType_text_inmediate"
        case .a:
            return "sendType_text_express"
        case .four, .zero:
            return nil
        }
    }
    
    var limitAmount: AmountRepresentable {
        switch self {
        case .eight:
            return AmountDTO(value: Decimal(5000), currency: .create(.złoty))
        case .a:
            return AmountDTO(value: Decimal(20000), currency: .create(.złoty))
        case .zero, .one, .four:
            return AmountDTO(value: .zero, currency: .create(.złoty))
        }
    }
}
