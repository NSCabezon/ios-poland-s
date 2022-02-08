//
//  PLSendMoneyOperative.swift
//  Santander
//

import CoreFoundationLib
import OpenCombine
import Transfer
import UIKit
import UI

final class PLSendMoneyOperative: AccountOperativeActionTypeProtocol {
    var rawValue: String = "accountOptionButtonTransferPoland"
    var trackName: String? = "accountOptionButtonTransferPoland"
    var accessibilityIdentifier: String? = "accountOptionButtonTransfer"
    private let title: String = "accountOption_button_transfer"
    private let icon: String = "icnSendMoney"
    
    let dependenciesResolver: DependenciesResolver
    private let dependencies: OneTransferHomeExternalDependenciesResolver
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.dependencies = dependenciesResolver.resolve()
    }
    
    func values() -> (title: String, imageName: String) {
        return (self.title, self.icon)
    }
    
    func getViewType(isSmartGP: Bool) -> ActionButtonFillViewType {
        return .defaultButton(DefaultActionButtonViewModel(title: self.title,
                                                           imageKey: self.icon,
                                                           titleAccessibilityIdentifier: self.accessibilityIdentifier ?? "",
                                                           imageAccessibilityIdentifier: self.icon))
    }
    
    func getAction() -> AccountOperativeAction {
        return .custom { [weak self] in
            guard let self = self else { return }
            self.useCase
                .fetchEnabled()
                .receive(on: Schedulers.main)
                .sink { [unowned self] isEnabled in
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                        if isEnabled {
                            self.dependencies.oneTransferHomeCoordinator().start()
                        } else {
                            self.sendMoneyCoordinator.start()
                        }
                    })
                    
                }
                .store(in: &self.subscriptions)
        }
    }
}

private extension PLSendMoneyOperative {
    var useCase: CheckNewSendMoneyHomeEnabledUseCase {
        return dependenciesResolver.resolve()
    }
    
    var sendMoneyCoordinator: SendMoneyCoordinatorProtocol {
        return dependenciesResolver.resolve()
    }
}
