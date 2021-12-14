import Foundation

public enum AccessibilityBLIK {
    
    // MARK: - BLIK home

    public enum BLIKView: String, AccessibilityIdentifiable {
        case root
        case codeLabel
        case progressBar
        case expirationLabel
        case copyButton
        case generateButton
        case descriptionLabel
    }
    
    public enum MenuView: String, AccessibilityIdentifiable {
        case root
        case imageView
        case titleLabel
        case descriptionLabel
        case disclosureIndicator
    }
    
    // MARK: - BLIK transaction - confirmation

    public enum ConfirmationProgressView: String, AccessibilityIdentifiable {
        case root
        case progressBar
        case expirationLabel
        case infoLabel
    }
    
    public enum ConfirmationOperativeSummary: String, AccessibilityIdentifiable {
        case root
        case itemAmount
        case itemTransferType
        case itemAddress
        case itemDate
        case aliasLabel
    }
    
    // MARK: - BLIK transaction - summary
    
    public enum SummaryOperativeSummary: String, AccessibilityIdentifiable {
        case itemAmount
        case itemTransferType
        case itemAddress
        case itemDate
        case actionLogout
        case footerAnotherCode
        case footerGlobalPosition
        case footerImprove
    }
    
    // MARK: - BLIK transaction - cancel transaction
    
    public enum CancelTransaction: String, AccessibilityIdentifiable {
        case imageView
        case infoLabel
    }
}
