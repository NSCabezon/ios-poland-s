import Foundation
import SANPLLibrary
import Commons
import SANLegacyLibrary
import Models

struct BLIKTransactionViewModel {
    
    private var transaction: Transaction

    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    var trnId: Int {
        transaction.transactionId
    }

    var title: String {
        transaction.title
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: transaction.date ?? Date())
    }
    
    var remainingTime: TimeInterval {
        let differenceInSeconds = transaction.time?.timeIntervalSince(Date()) ?? 0
        return differenceInSeconds
    }
    
    var transferType: Transaction.TransferType {
        transaction.transferType
    }

    var transferTypeString: String {
        switch transaction.transferType {
        case .blikPurchases:
            return localized("pl_blik_text_shopStatus")
        case .blikCashback:
            return localized("pl_blik_text_cashBackStatus")
        case .blikAtmWithdrawal:
            return localized("pl_blik_text_atmPayBlikStatus")
        case .blikCashAdvance:
            return localized("pl_blik_text_cashAdvStatus")
        case .blikWebPurchases:
            return localized("pl_blik_text_shopOnlineStatus")
        case .blikPosRefund, .blikWebRefund:
            return localized("pl_blik_text_returnStatus")
        case .blikAtmWithdrawalPsp:
            return localized("pl_blik_text_atmPayStatus")
        }
    }
    
    var address: String? {
        let merchantString = [transaction.placeName, transaction.address, transaction.city]
            .compactMap { $0 }.joined(separator: " ")
        return merchantString.isEmpty ? nil : merchantString
    }

    func amountString(withAmountSize size: CGFloat) -> NSAttributedString {
        AmountFormatter.amountString(amount: transaction.amount, currency: .złoty, withAmountSize: size)
    }
    
    var transactionDate: String {
        DateFormats.toString(date: transaction.date ?? Date(), output: .YYYYMMDD)
    }
    
    var aliasLabelUsedInTransaction: String? {
        switch transaction.aliasContext {
        case let .transactionWasPerformedWithAlias(alias):
            return alias.label
        case .none, .receivedAliasProposal:
            return nil
        }
    }
    
    var proposedAlias: Transaction.AliasProposal? {
        switch transaction.aliasContext {
        case let .receivedAliasProposal(proposal):
            return proposal
        case .none, .transactionWasPerformedWithAlias:
            return nil
        }
    }
}
