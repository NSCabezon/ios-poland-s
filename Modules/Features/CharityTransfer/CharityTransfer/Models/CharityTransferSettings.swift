
public struct CharityTransferSettings {
    
    let transferRecipientName: String?
    let transferAccountNumber: String?
    let transferTitle: String?
    
    public init(transferRecipientName: String?,
                transferAccountNumber: String?,
                transferTitle: String?) {
        self.transferTitle = transferTitle
        self.transferRecipientName = transferRecipientName
        self.transferAccountNumber = transferAccountNumber
    }
    
}
