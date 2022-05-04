import PersonalArea
import CoreFoundationLib
import UI

final class PLSecurityActionBuilder {
    public var actions: [SecurityActionViewModelProtocol] = []
    private let securityActionComponents: SecurityActionComponentsProtocol
    private var userPref: UserPrefWrapper
    
    init(userPreference: UserPrefWrapper) {
        self.securityActionComponents = SecurityActionComponents(userPreference)
        self.userPref = userPreference
    }
    
    func addPhone() -> Self {
        guard userPref.isValidPhone else { return self }
        guard let viewModel = self.securityActionComponents.addPhone(.noAction) else { return self }
        self.actions.append(viewModel)
        return self
    }
    
    func addMail() -> Self {
        guard userPref.isValidEmail else { return self }
        guard let viewModel = self.securityActionComponents.addMail(.noAction) else { return self }
        self.actions.append(viewModel)
        return self
    }
    
    func addBiometrySystem(customAction: CustomAction? = nil) -> Self {
        guard let viewModel = self.securityActionComponents.addBiometrySystem(customAction: customAction) else { return self }
        self.actions.append(viewModel)
        return self
    }
    
    func addGeolocation() -> Self {
        let viewModel = self.securityActionComponents.addGeolocation()
        self.actions.append(viewModel)
        return self
    }
    
    func addQuickerBalance() -> Self {
        let name: String = "quickBalance_title_quickBalance"
        let action: () -> Void = {             Toast.show(localized("generic_alert_notAvailableOperation")) }
        let accessibilityIdentifiers: [SecurityActionAccessibilityIdentifierType: String] = [
            .container: AccessibilitySecurityAreaAction.quickBalanceContainer,
            .action: AccessibilitySecurityAreaAction.quickBalanceAction,
            .tooltip: AccessibilitySecurityAreaAction.quickBalanceTooltipAction
        ]
        let viewModel = self.securityActionComponents.addCustom(
            action: .changePassword,
            name: name,
            value: nil,
            toolTip: nil,
            accessibilityIdentifiers: accessibilityIdentifiers,
            externalAction: action)
        self.actions.append(viewModel)
        return self
    }
    
    func addChangePin() -> Self {
        let name: String = "pl_personalArea_label_changePIN"
        let action: () -> Void = {             Toast.show(localized("generic_alert_notAvailableOperation")) }
        let accessibilityIdentifiers: [SecurityActionAccessibilityIdentifierType: String] = [
            .container: AccessibilitySecurityAreaAction.changePinContainer,
            .action: AccessibilitySecurityAreaAction.operativityAction,
            .tooltip: AccessibilitySecurityAreaAction.changePinTooltip,
            .value: AccessibilitySecurityAreaAction.operativityFilledValue
        ]
        let viewModel = self.securityActionComponents.addCustom(
            action: .changePassword,
            name: name,
            value: nil,
            toolTip: nil,
            accessibilityIdentifiers: accessibilityIdentifiers,
            externalAction: action)
        self.actions.append(viewModel)
        return self
    }
    
    func addChangePassword() -> Self {
        let name: String = "personalArea_label_keyChange"
        let action: () -> Void = {             Toast.show(localized("generic_alert_notAvailableOperation")) }
        let accessibilityIdentifiers: [SecurityActionAccessibilityIdentifierType: String] = [
            .container: AccessibilitySecurityAreaAction.passwordContainer,
            .action: AccessibilitySecurityAreaAction.passwordAction,
            .tooltip: AccessibilitySecurityAreaAction.operativityTooltipAction,
            .value: AccessibilitySecurityAreaAction.operativityFilledValue
        ]
        let viewModel = self.securityActionComponents.addCustom(
            action: .changePassword,
            name: name,
            value: nil,
            toolTip: nil,
            accessibilityIdentifiers: accessibilityIdentifiers,
            externalAction: action)
        self.actions.append(viewModel)
        return self
    }
    
    func addPasswordSignatureKey() -> Self {
        let viewModel = self.securityActionComponents.addPasswordSignatureKey()
        self.actions.append(viewModel)
        return self
    }
    
    public func build() -> [SecurityActionViewModelProtocol] {
        return self.actions
    }
}
