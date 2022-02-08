import CoreFoundationLib
import UI
import PLCommonOperatives
import ZusTransfer

final class PLTransferZusOperative: AccountOperativeActionTypeProtocol {
    #warning("todo: change below when icons and texts are available")
    let rawValue: String = "transferZusPoland"
    let trackName: String? = "transferZusPoland"
    let accessibilityIdentifier: String? = "accountOptionButtonTransferZus"
    private let dependenciesResolver: DependenciesResolver
    private let title: String = "accountOption_button_TransferZus"
    private let icon: String = "icnPayTax"
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }

    func values() -> (title: String, imageName: String) {
        return (title, icon)
    }

    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        return .defaultButton(
            DefaultActionButtonViewModel(
                title: title,
                imageKey: icon,
                titleAccessibilityIdentifier: accessibilityIdentifier ?? "",
                imageAccessibilityIdentifier: icon
            )
        )
    }

    func getAction() -> AccountOperativeAction {
        return .custom {
            let coordinator = self.dependenciesResolver.resolve(
                for: ZusTransferModuleCoordinatorProtocol.self
            )
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(
                animated: true,
                completion: {
                    coordinator.start()
                })
        }
    }
}
