//
//  OtherBlikSettingsCoordinator.swift
//  BLIK
//
//  Created by 186491 on 10/08/2021.
//

import UI
import Models
import Commons
import SANPLLibrary

protocol OtherBlikSettingsCoordinatorProtocol: ModuleCoordinator {
    func showHelp()
    func close()
}

final class OtherBlikSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let wallet: GetWalletUseCaseOkOutput.Wallet

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        wallet: GetWalletUseCaseOkOutput.Wallet
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.wallet = wallet
    }
    
    public func start() {
        let presenter = OtherBlikSettingsPresenter(
            viewModel: OtherBlikSettingsViewModel(
                blikCustomerLabel: wallet.alias.label,
                isTransactionVisible: wallet.noPinTrnVisible
            ),
            coordinator: self
        )
        let viewController = OtherBlikSettingsViewController(
            presenter: presenter
        )
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension OtherBlikSettingsCoordinator: OtherBlikSettingsCoordinatorProtocol {
    func showHelp() {
        showEmptyController()
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showEmptyController() {
        let emptyController = UIViewController()
        emptyController.view.backgroundColor = .white
        navigationController?.pushViewController(emptyController, animated: true)
    }
}
