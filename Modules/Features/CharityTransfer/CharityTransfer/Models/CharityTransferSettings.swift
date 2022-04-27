
public struct CharityTransferSettings {
    let transferRecipientName: String?
    let transferAccountNumber: String?
    let transferTitle: String?
    let windowTitle: String?
    let infoText: String?
    
    public init(
        transferRecipientName: String?,
        transferAccountNumber: String?,
        transferTitle: String?,
        windowTitle: String?,
        infoText: String?
    ) {
        self.transferTitle = transferTitle
        self.transferRecipientName = transferRecipientName
        self.transferAccountNumber = transferAccountNumber
        self.windowTitle = windowTitle
        self.infoText = infoText
    }
}
