
struct InvalidTransferFormMessages {
    let tooShortPhoneNumberMessage: String?
    let tooLowAmount: String?
    let tooMuchAmount: String?
    
    var shouldContinueButtonBeEnabled: Bool {
        tooLowAmount == nil && tooMuchAmount == nil && tooShortPhoneNumberMessage == nil
    }
}
