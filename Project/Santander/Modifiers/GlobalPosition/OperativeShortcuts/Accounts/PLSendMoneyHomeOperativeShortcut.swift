import CoreFoundationLib
import RetailLegacy
import OpenCombine
import Transfer
import UI

final class PLSendMoneyHomeOperativeShortcut {
    private let legacyDependenciesResolver: DependenciesResolver
    private let dependencies: ModuleDependencies
    private var subscriptions: Set<AnyCancellable> = []

    var trackName: String? = "accountOptionButtonTransferPoland"
    
    init(dependencies: ModuleDependencies) {
        self.legacyDependenciesResolver = dependencies.resolve()
        self.dependencies = dependencies
    }
}

extension PLSendMoneyHomeOperativeShortcut: AccountOperativeActionTypeProtocol {
    var rawValue: String {
        return "accountOptionButtonTransferPoland"
    }
    
    var title: String {
        return "accountOption_button_transfer"
    }
    
    var icon: String {
        return "icnSendMoney"
    }
    
    var accessibilityIdentifier: String? {
        return "accountOptionButtonTransfer"
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
        return .custom { [weak self] in
            guard let self = self else { return }
            self.checkNewSendMoneyHomeIsEnabled
                .fetchEnabled()
                .receive(on: Schedulers.main)
                .sink { [unowned self] isEnabled in
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true) {
                        if isEnabled {
                            self.dependencies.oneTransferHomeCoordinator().start()
                        } else {
                            self.sendMoneyCoordinator.start()
                        }
                    }
                }
                .store(in: &self.subscriptions)
        }
    }
}

private extension PLSendMoneyHomeOperativeShortcut {
    var checkNewSendMoneyHomeIsEnabled: CheckNewSendMoneyHomeEnabledUseCase {
        return dependencies.resolve()
    }
    
    var sendMoneyCoordinator: SendMoneyCoordinatorProtocol {
        return legacyDependenciesResolver.resolve()
    }
}
