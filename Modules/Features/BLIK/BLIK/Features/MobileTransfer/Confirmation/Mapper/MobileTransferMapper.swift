import Foundation
import CoreFoundationLib
import PLUI
import PLCommons

protocol MobileTransferMapping {
    func map(form: MobileTransferForm,
             account: AccountForDebit) -> MobileTransfer
}

final class MobileTransferMapper: MobileTransferMapping {

    func map(form: MobileTransferForm, account: AccountForDebit) -> MobileTransfer {
        MobileTransfer(amount: form.amount,
                       title: form.title,
                       account: account,
                       recipientName: form.recipent,
                       phoneNumber: form.phoneNumber,
                       date: form.date)
    }
}
