//
//  BLIKHomeCoordinator.swift
//  Pods
//
//  Created by 186488 on 31/05/2021.
//  

import UI
import Models
import Commons
import DataRepository
import SANPLLibrary
import PLCommons
import PLCryptography
/**
    #Add method that must be handle by the BLIKHomeCoordinator like 
    navigation between the module scene and so on.
*/
protocol BLIKHomeCoordinatorProtocol {
    func pop()
    func showCheques(with wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>)
    func showBLIKConfirmation(viewModel: BLIKTransactionViewModel)
    func showSettings(with wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>)
    func showContacts()
    func showAliasPayment()
}

public final class BLIKHomeCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: BLIKHomeViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension BLIKHomeCoordinator: BLIKHomeCoordinatorProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func showCheques(with wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>) {
        let coordinator = ChequesCoordinator(
            navigationController: navigationController,
            shouldCofigurePin: wallet.getValue().shouldSetChequePin,
            chequesFactory: ChequesFactory(dependenciesResolver: dependenciesEngine),
            chequesPinFactory: ChequesPinFactory(dependenciesResolver: dependenciesEngine),
            chequeFormFactory: ChequeFormFactory(dependenciesResolver: dependenciesEngine),
            chequesDetailsFactory: ChequesDetailsFactory(dependenciesResolver: dependenciesEngine)
        )
        coordinator.start()
    }
    
    func showBLIKConfirmation(viewModel: BLIKTransactionViewModel) {
        let coordinator = BLIKConfirmationCoordinator(dependenciesResolver: dependenciesEngine,
                                                      navigationController: navigationController,
                                                      viewModel: viewModel)
        
        coordinator.start()
    }
    
    func showSettings(with wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>) {
        let coordinator = BlikSettingsCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            wallet: wallet
        )
        coordinator.start()
    }
    
    func showContacts() {
        let cooridinator = ContactsCoordinator(dependenciesResolver: dependenciesEngine,
                                               navigationController: navigationController)
        
        cooridinator.start()
    }
    
    func showAliasPayment() {
        let coordinator = AliasListSettingsCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController
        )
        coordinator.start()
    }
}

/**
 #Register Scene depencencies.
*/

private extension BLIKHomeCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: BLIKHomeCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: BLIKHomePresenterProtocol.self) { resolver in
            return BLIKHomePresenter(dependenciesResolver: resolver)
        }
         
        self.dependenciesEngine.register(for: BLIKHomeViewController.self) { resolver in
            var presenter = resolver.resolve(for: BLIKHomePresenterProtocol.self)
            let viewController = BLIKHomeViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        
        self.dependenciesEngine.register(for: NetworkProvider.self) { resolver in
            return PLNetworkProvider(
                dataProvider: BSANDataProvider(
                    dataRepository: resolver.resolve(for: DataRepository.self)
                ),
                demoInterpreter: resolver.resolve(for: DemoUserProtocol.self),
                isTrustInvalidCertificateEnabled: false,
                trustedHeadersProvider: resolver.resolve(
                    for: PLTrustedHeadersGenerable.self
                )
            )
        }
        
        self.dependenciesEngine.register(for: DemoUserProtocol.self) { resolver in
            return DemoUserInterpreter(
                bsanDataProvider: BSANDataProvider(
                    dataRepository: resolver.resolve(for: DataRepository.self)
                ),
                defaultDemoUser: "user"
            )
        }
        
        self.dependenciesEngine.register(for: DataRepository.self) { resolver in
            return DataRepositoryImpl(
                dataSourceProvider: resolver.resolve(for: DataSourceProvider.self),
                appInfo: VersionInfoDTO(bundleIdentifier: "test", versionName: "1.0")
            )
        }
        
        self.dependenciesEngine.register(for: DataSourceProvider.self) { resolver in
            return DataSourceProviderImpl(
                defaultDataSource: MemoryDataSource(),
                dataSources: [MemoryDataSource()]
            )
        }
        
        self.dependenciesEngine.register(for: GetWalletsActiveProtocol.self) { resolver in
            return GetWalletsActiveUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetPSPTicketProtocol.self) { resolver in
            return GetPSPTicket(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetTrnToConfProtocol.self) { resolver in
            return GetTrnToConfUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: ChequeModelMapping.self) { resolver in
            return ChequeModelMapper(
                dateFormatter: PLTimeFormat.YYYYMMDD_HHmmssSSS.createDateFormatter()
            )
        }
        dependenciesEngine.register(for: PLTrustedHeadersGenerable.self) { resolver in
             PLTrustedHeadersProvider(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PLDomesticTransactionParametersGenerable.self) { _ in
             PLDomesticTransactionParametersProvider()
        }
        dependenciesEngine.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
             PLTransactionParametersProvider(dependenciesResolver: resolver)
        }
    }
}
