protocol BlikCustomerLabelValidating {
    func validate(_ label: String) -> BlikCustomerLabelValidationResult
}

final class BlikCustomerLabelValidator: BlikCustomerLabelValidating {
    func validate(_ label: String) -> BlikCustomerLabelValidationResult {
        if label.isEmpty {
            return .invalid(.emptyText)
        }
        
        if label.count > 20 {
            return .invalid(.exceededMaximumLength)
        }
        
        let regExpPattern = "^[a-zA-Z0-9ąęćółńśżźĄĘĆÓŁŃŚŻŹ\"\\.\\:\\- ]*$"
        let regExpValidationResult = label.range(of: regExpPattern, options: .regularExpression)
        if regExpValidationResult != nil {
            return .valid
        } else {
            return .invalid(.illegalCharacters)
        }
    }
}
