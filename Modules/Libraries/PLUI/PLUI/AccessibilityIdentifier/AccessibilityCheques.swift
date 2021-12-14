import Foundation

public enum AccessibilityCheques {
    
    // MARK: - Cheque List

    public enum ChequeList: String, AccessibilityIdentifiable {
        case tableView
        case refreshControl
    }
    
    public enum ChequeCell: String, AccessibilityIdentifiable {
        case root
        case title
        case amount
        case icon
    }
    
    public enum EmptyDataMessageCell: String, AccessibilityIdentifiable {
        case root
        case title
        case message
        case backgroundImage
    }
    
    public enum ErrorCell: String, AccessibilityIdentifiable {
        case root
        case icon
        case title
        case subtitle
        case refreshButton
    }
    
    // MARK: - Cheque Pin

    public enum ChequePinView: String, AccessibilityIdentifiable {
        case hintLabel
        case lockImageView
        case titleLabel
        case pinLabel
        case pinInput
        case pinConfirmationLabel
        case pinConfirmationInput
        case footerView
        case saveButton
    }
    
    public enum PinInputView: String, AccessibilityIdentifiable {
        case inputItem
    }
    
    // MARK: - Cheque Details

    public enum ChequeDetailsCell: String, AccessibilityIdentifiable {
        case root
        case titleLabel
        case dataLabel
    }
    
    public enum ChequeDetailsFooterView: String, AccessibilityIdentifiable {
        case root
        case sendButton
        case removeButton
    }
   
    // MARK: - Cheque Form

    public enum ChequeValidityPeriodSelectorView: String, AccessibilityIdentifiable {
        case root
        case dropdownView
    }
    
    public enum CurrencyLabel: String, AccessibilityIdentifiable {
        case root
        case label
    }
    
    public enum ChequeFormView: String, AccessibilityIdentifiable {
        case amount
        case amountLimit
        case name
    }
}
