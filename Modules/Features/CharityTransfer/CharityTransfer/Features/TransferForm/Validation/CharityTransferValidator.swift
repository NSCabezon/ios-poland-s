
import Foundation
import CoreFoundationLib

struct CharityTransferValidator {
    
    func  validateForm(form: CharityTransferFormViewModel) -> InvalidCharityTransferFormMessages {
        var tooLowAmount: String?
        var tooMuchAmount: String?
        if let amount = form.amount, amount <= 0 {
            tooLowAmount = localized("charity_transfer_form_amount_min_error")
        }
        if let amount = form.amount, amount > 100_000 {
            tooMuchAmount = localized("charity_transfer_form_amount_max_error")
        }
        return InvalidCharityTransferFormMessages(tooLowAmount: tooLowAmount,
                                                  tooMuchAmount: tooMuchAmount)
    }
}
