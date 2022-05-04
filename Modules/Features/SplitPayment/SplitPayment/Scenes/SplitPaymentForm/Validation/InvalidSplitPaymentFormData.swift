struct InvalidSplitPaymentFormData {
    let invalidRecieptMessages: String?
    let invalidAccountMessages: String?
    let invalidNipAmountMessages: String?
    let invalidGrossAmountMessages: String?
    let invalidVatAmountMessages: String?
    let invalidInvoiceTitleMessages: String?
    let invalidTitleMessages: String?
    let currentActiveField: TransferFormCurrentActiveField
    let showWhiteListInfoSection: Bool
        
    var shouldContinueButtonBeEnabled: Bool {
        let validReciept = invalidRecieptMessages == nil
        let validAccount = invalidAccountMessages == nil
        let validNip = invalidNipAmountMessages == nil
        let validGrossAmount = invalidGrossAmountMessages == nil
        let validVatAmount = invalidVatAmountMessages == nil
        let validInvoiceTitle = invalidInvoiceTitleMessages == nil
        let validTitle = invalidTitleMessages == nil
        return validReciept &&
            validAccount &&
            validNip &&
            validGrossAmount &&
            validVatAmount &&
            validInvoiceTitle &&
            validTitle
    }
}
