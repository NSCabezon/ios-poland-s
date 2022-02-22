import Foundation
import CoreFoundationLib

struct MobileTransferFormValidator {
    
    func validateForm(form: MobileTransferForm, validateNumber: Bool) -> InvalidMobileTransferFormMessages {
        var toShortNumberMessage: String?
        var tooLowAmount: String?
        var tooMuchAmount: String?
        if validateNumber, let phoneNumber = form.phoneNumber, phoneNumber.count < 9 {
            if phoneNumber.isEmpty {
                toShortNumberMessage = localized("pl_generic_validationText_thisFieldCannotBeEmpty")
            } else {
                toShortNumberMessage = localized("pl_generic_validationText_upTo9Characters")
            }
        }
        if let amount = form.amount, amount < 0.02 {
            tooLowAmount = localized("pl_blikP2P_validationText_minimalTransfer")
        }
        if let amount = form.amount, amount > 100000 {
            tooMuchAmount = localized("pl_generic_validationText_amountLessThan100000")
        }
        return InvalidMobileTransferFormMessages(tooShortPhoneNumberMessage: toShortNumberMessage, tooLowAmount: tooLowAmount, tooMuchAmount: tooMuchAmount)
    }
}
