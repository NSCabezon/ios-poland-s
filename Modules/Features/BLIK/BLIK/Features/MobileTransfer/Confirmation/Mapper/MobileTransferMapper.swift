import Foundation
import Commons
import PLUI

protocol MobileTransferMapping {
    func map(form: MobileTransferForm,
             account: SelectableAccountViewModel) -> MobileTransfer
}

final class MobileTransferMapper: MobileTransferMapping {

    func map(form: MobileTransferForm, account: SelectableAccountViewModel) -> MobileTransfer {
        MobileTransfer(amount: form.amount?.doubleValue,
                       title: form.title,
                       account: account,
                       recipientName: form.recipent,
                       phoneNumber: form.phoneNumber,
                       date: form.date)
    }
}
