//
//  PLMakeDonationOperative.swift
//  Santander
//

import CoreFoundationLib
import UI
import Commons
import PLCommonOperatives
import CharityTransfer

final class PLMakeDonationOperative: AccountOperativeActionTypeProtocol {
    let dependenciesResolver: DependenciesResolver
    var rawValue: String = "makeDonationPoland"
    var trackName: String? = "makeDonationPoland"
    var accessibilityIdentifier: String? = "accountOption_button_donations"
    private let title: String = "accountOption_button_donations"
    private let icon: String = "icnDonations"
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
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
        return .custom {
            Scenario(useCase: GetAccountsForDebitUseCase(transactionType: .charityTransfer, dependenciesResolver: self.dependenciesResolver))
                .execute(on: self.dependenciesResolver.resolve())
                .onSuccess { [weak self] accounts in
                    guard let self = self, !accounts.isEmpty else {
                        Toast.show(localized("generic_alert_notAvailableOperation"))
                        return
                    }
                    let repository = self.dependenciesResolver.resolve(for: PLTransferSettingsRepository.self)
                    let settings = repository.get()?.charityTransfer
                    let charityTransferSettings = CharityTransferSettings(transferRecipientName: settings?.transferRecipientName,
                                                                          transferAccountNumber: settings?.transferAccountNumber,
                                                                          transferTitle: settings?.transferTitle)
                    let coordinator: CharityTransferModuleCoordinator = self.dependenciesResolver.resolve()
                    coordinator.setProperties(accounts: accounts, charityTransferSettings: charityTransferSettings)
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                        coordinator.start()
                    })
                }
                .onError { _ in
                    Toast.show(localized("generic_alert_notAvailableOperation"))
                }
        }
    }
}
