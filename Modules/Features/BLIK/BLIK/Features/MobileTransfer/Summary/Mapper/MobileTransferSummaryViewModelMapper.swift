import Foundation
import CoreFoundationLib
import SANPLLibrary

protocol MobileTransferSummaryViewModelMapping {
    func map(transaction: BlikTransactionDTO) -> MobileTransferSummaryViewModel
}

final class MobileTransferSummaryViewModelMapper: MobileTransferSummaryViewModelMapping {
    func map(transaction: BlikTransactionDTO) -> MobileTransferSummaryViewModel {
        if let aliaces = transaction.aliases,
           let auth = aliaces.auth {
            if let type = auth.type, let label = auth.label {
                return .trustedDevice(.init(label: label, type: type))
            } else {
                return .none
            }
        } else {
            if let proposal = transaction.aliases?.proposal.first,
               let type = proposal.type,
               let alias = proposal.alias {

                return .untrustedDevice(.init(alias: alias, type: type))
            } else {
                return .none
            }
        }
    }
}
