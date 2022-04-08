enum TransferFormCurrentActiveField {
    case recipient
    case accountNumber(controlEvent: AccountControlEvent)
    case nip
    case grossAmount
    case vatAmount
    case invoiceTitle
    case title
    case date
    case none
    
    enum AccountControlEvent {
        case beginEditing
        case endEditing
    }
}
