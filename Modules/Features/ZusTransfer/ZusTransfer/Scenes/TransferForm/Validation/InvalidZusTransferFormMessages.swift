struct InvalidZusTransferFormMessages {
    let tooLowAmount: String?
    let tooMuchAmount: String?
    
    var shouldContinueButtonBeEnabled: Bool {
        tooLowAmount == nil && tooMuchAmount == nil
    }
}
