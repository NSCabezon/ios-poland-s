struct InvalidZusSmeTransferFormData {
    let invalidRecieptMessages: String?
    let invalidAccountMessages: String?
    let invalidAmountMessages: String?
    let invalidTitleMessages: String?
    let currentActiveField: TransferFormCurrentActiveField
        
    var shouldContinueButtonBeEnabled: Bool {
        let validReciept = invalidRecieptMessages == nil
        let validAccount = invalidAccountMessages == nil
        let validAmount = invalidAmountMessages == nil
        let validTitle = invalidTitleMessages == nil
        return validReciept && validAccount && validAmount && validTitle
    }
}
