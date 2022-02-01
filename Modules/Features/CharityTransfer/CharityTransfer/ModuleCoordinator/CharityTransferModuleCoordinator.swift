//
//  CharityTransferModuleCoordinator.swift
//  Account
//
//  Created by 187125 on 03/01/2022.
//

import UI
import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import PLUI

public protocol CharityTransferModuleCoordinatorProtocol {}

public final class CharityTransferModuleCoordinator: ModuleCoordinator {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var accounts: [AccountForDebit]?
    private var charityTransferSettings: CharityTransferSettings?

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
    }
    
    public func setProperties(accounts: [AccountForDebit],
                         charityTransferSettings: CharityTransferSettings) {
        self.accounts = accounts
        self.charityTransferSettings = charityTransferSettings
    }

    public func start() {
        guard let accounts = accounts, let charityTransferSettings = charityTransferSettings else { return }
        if accounts.contains(where: { $0.defaultForPayments == true }) || accounts.count == 1 {
            let selectedAccountNumber = accounts.first(where: { $0.defaultForPayments })?.number ?? accounts.first?.number ?? ""
            let coordinator = CharityTransferFormCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController,
                accounts: accounts,
                selectedAccountNumber: selectedAccountNumber,
                charityTransferSettings: charityTransferSettings
            )
            coordinator.start()
            return
        }
        let coordinator = CharityTransferAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: "",
            sourceView: .sendMoney,
            charityTransferSettings: charityTransferSettings
        )
        coordinator.start()
    }
}

extension CharityTransferModuleCoordinator: CharityTransferModuleCoordinatorProtocol {}

