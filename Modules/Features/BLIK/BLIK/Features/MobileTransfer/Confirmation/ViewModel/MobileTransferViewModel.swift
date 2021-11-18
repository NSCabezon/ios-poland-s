import Foundation
import SANPLLibrary
import Commons
import PLCommons
import SANLegacyLibrary
import Models
import PLUI

public struct MobileTransferViewModel {
    
    private var transfer: MobileTransfer

    init(transfer: MobileTransfer) {
        self.transfer = transfer
    }

    var title: String {
        if let title = transfer.title, !title.isEmpty {
            return title
        } else {
            return localized("pl_blik_text_title_phoneTransferDeflt")
        }
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: transfer.date ?? Date())
    }
    
    var recipientName: String {
        let msisdnPhoneFormatter = MSISDNPhoneNumberFormatter()
        if let recipient = transfer.recipientName, !recipient.isEmpty {
            return recipient
        } else {
            let formattedNumber = msisdnPhoneFormatter.polishCountryCodeAppendedNumber(formattedNumber: FormattedNumberMetadata(formattedNumber: transfer.phoneNumber ?? "", unformattedNumber: transfer.phoneNumber ?? ""))?.formattedNumber ?? ""
            let phoneFirst2Digits = formattedNumber.substring(0, 2) ?? ""
            let phoneLast3Digits = formattedNumber.substring(ofLast: 3) ?? ""
            let hiddenCharactrs = Array(repeating: "X", count: (formattedNumber.count) - 5).joined()
            return phoneFirst2Digits + hiddenCharactrs + phoneLast3Digits
        }
    }
    
    var transferType: String {
        localized("pl_blik_label_transferTypeSumm")
    }
    
    var trimmedPhoneNumber: String {
        let msisdnPhoneFormatter = MSISDNPhoneNumberFormatter()
        return msisdnPhoneFormatter.polishCountryCodeAppendedNumber(formattedNumber: FormattedNumberMetadata(formattedNumber: transfer.phoneNumber ?? "", unformattedNumber: transfer.phoneNumber ?? ""))?.formattedNumber ?? ""
    }
    var phoneNumber: String {
        let plPhoneNumberFormatter = PLPhoneNumberTextFieldFormatter()
        return plPhoneNumberFormatter.formatStrnig(numberInString: trimmedPhoneNumber)
    }

    func amountString(withAmountSize size: CGFloat) -> NSAttributedString {
        AmountFormatter.amountString(
            amount: transfer.amount ?? 0,
            currency: .złoty,
            withAmountSize: size
        )
    }
    
    var accountName: String {
        transfer.account.name
    }
    
    var accountNumber: String {
        let formattedAccountNumber = IBANFormatter.format(iban: transfer.account.accountNumberUnformatted)
        return formattedAccountNumber
    }
    
    var account: SelectableAccountViewModel {
        transfer.account
    }
    
    var amount: Decimal {
        transfer.amount ?? 0
    }
    
    var date: Date? {
        transfer.date
    }
}
