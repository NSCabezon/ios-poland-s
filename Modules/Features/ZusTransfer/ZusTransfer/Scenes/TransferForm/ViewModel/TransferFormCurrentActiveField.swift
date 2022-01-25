enum TransferFormCurrentActiveField {
    case recipient
    case accountNumber(controlEvent: AccountControlEvent)
    case amount
    case title
    case date
    case none
    
    enum AccountControlEvent {
        case beginEditing
        case endEditing
    }
}
