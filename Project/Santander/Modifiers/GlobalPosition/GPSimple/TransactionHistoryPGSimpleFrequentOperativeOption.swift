import CoreFoundationLib
import UI

final class TransactionHistoryPGSimpleFrequentOperativeOption {
    let trackName: String? = "transactionHistory"
    let rawValue: String = "transactionHistoryPoland"
    let accessibilityIdentifier: String? = PLAccessibilityPGFrequentOperatives.btnTransactionHistory.rawValue
}

extension TransactionHistoryPGSimpleFrequentOperativeOption: PGFrequentOperativeOptionProtocol {
    func getAction() -> PGFrequentOperativeOptionAction {
        return .custom {
            Toast.show(localized("generic_alert_notAvailableOperation"))
        }
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        let imageKey: String = "oneIcnTransHistory"
        let titleKey: String = "frequentOperative_button_transHistory"
        return .defaultButton(
            DefaultActionButtonViewModel(
                title: titleKey,
                imageKey: imageKey,
                titleAccessibilityIdentifier: titleKey,
                imageAccessibilityIdentifier: imageKey
            )
        )
    }

    func getEnabled() -> PGFrequentOperativeOptionEnabled {
        return .custom(enabled: { return true })
    }

    func getLocation() -> String? {
        return nil
    }
}
