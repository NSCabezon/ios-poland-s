import Foundation

public enum AccessibilityCommons {
    
    public enum TotalAmountView: String, AccessibilityIdentifiable {
        case root
        case titleLabel
        case totalLabel
    }
    
    public enum BottomButtonView: String, AccessibilityIdentifiable {
        case root
        case button
    }
}
