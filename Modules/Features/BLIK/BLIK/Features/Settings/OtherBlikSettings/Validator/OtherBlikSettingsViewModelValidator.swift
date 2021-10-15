protocol OtherBlikSettingsViewModelValidating {
    func validate(_ model: OtherBlikSettingsViewModel) -> Bool
}

enum OtherBlikSettingsAllowedCharacters: String {
    case blikLabel = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890\"ąęćółńśżźĄĘĆÓŁŃŚŻŹ\\-"
    case blikLabelPattern = "^[a-zA-Z0-9ąęćółńśżźĄĘĆÓŁŃŚŻŹ\"\\\\-]*$"
}

final class OtherBlikSettingsViewModelValidator: OtherBlikSettingsViewModelValidating {
    func validate(_ model: OtherBlikSettingsViewModel) -> Bool {
        guard !model.blikCustomerLabel.isEmpty else {
            return false
        }
        
        let range = model.blikCustomerLabel.range(of: OtherBlikSettingsAllowedCharacters.blikLabelPattern.rawValue, options: .regularExpression)
        return range != nil
    }
}
