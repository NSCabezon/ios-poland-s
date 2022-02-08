//
//  ZusTransferModuleCoordinator.swift
//  ZusTransfer
//
//  Created by 187830 on 22/12/2021.
//

import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import PLUI

public protocol ZusTransferModuleCoordinatorProtocol {}

public final class ZusTransferModuleCoordinator: ModuleCoordinator {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accounts: [AccountForDebit]
    
    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        accounts: [AccountForDebit]
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
    }
    
    public func start() {
        if accounts.contains(where: { $0.defaultForPayments == true }) || accounts.count == 1 {
            let selectedAccountNumber = accounts.first(where: { $0.defaultForPayments })?.number ?? accounts.first?.number ?? ""
            let coordinator = ZusTransferFormCoordinator(
                dependenciesResolver: dependenciesEngine,
                navigationController: navigationController,
                accounts: accounts,
                selectedAccountNumber: selectedAccountNumber
            )
            coordinator.start()
            return
        }
        let coordinator = ZusAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: "",
            sourceView: .sendMoney
        )
        coordinator.start()
    }
}

extension ZusTransferModuleCoordinator: ZusTransferModuleCoordinatorProtocol {}
