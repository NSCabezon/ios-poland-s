//
//  File.swift
//  ScanAndPay
//
//  Created by 188216 on 16/03/2022.
//

import Foundation
import CoreFoundationLib
import UI

public protocol ScanAndPayScannerCoordinatorProtocol: AnyObject, ModuleCoordinator {
    func back(animated: Bool)
    func close(animated: Bool)
    func showSummary(with transferModel: QRTransferModel)
}

public final class ScanAndPayScannerCoordinator: ScanAndPayScannerCoordinatorProtocol {
    // MARK: Properties
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    // MARK: Lifecycle
    
    public init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    // MARK: SetUp
    
    private func setupDependencies() {
        self.dependenciesEngine.register(for: PreferencesStoreProtocol.self) { _ in
            return PreferencesStore()
        }
        
        self.dependenciesEngine.register(for: QRCodeDetectorProtocol.self) { _ in
            return QRCodeDetector()
        }

        self.dependenciesEngine.register(for: CameraPermissionsManagerProtocol.self) { _ in
            return CameraPermissionsManager()
        }

        self.dependenciesEngine.register(for: ScanAndPayScannerCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: ScanAndPayScannerPresenterProtocol.self) { resolver in
            return ScanAndPayScannerPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: ScanAndPayScannerViewController.self) { resolver in
            let presenter = resolver.resolve(for: ScanAndPayScannerPresenterProtocol.self)
            let viewController = ScanAndPayScannerViewController(
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        
    }
    
    // MARK: Methods
    
    public func start() {
        let controller = dependenciesEngine.resolve(for: ScanAndPayScannerViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    public func close(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    public func back(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    public func showSummary(with transferModel: QRTransferModel) {
        let summaryCoordinator = ScanAndPaySummaryCoordinator(dependenciesResolver: dependenciesEngine,
                                                              navigationController: navigationController,
                                                              transferModel: transferModel)
        summaryCoordinator.start()
    }
}
