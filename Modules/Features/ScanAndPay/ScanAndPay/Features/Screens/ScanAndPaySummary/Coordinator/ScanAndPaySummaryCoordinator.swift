//
//  ScanAndPaySummaryCoordinator.swift
//  ScanAndPay
//
//  Created by 188216 on 07/04/2022.
//

import Foundation
import CoreFoundationLib
import UI
import PLUI

protocol ScanAndPaySummaryCoordinatorProtocol: AnyObject {
    func back(animated: Bool)
    func close()
    func handleImageShare(image: UIImage)
}

final class ScanAndPaySummaryCoordinator: ScanAndPaySummaryCoordinatorProtocol {
    // MARK: Properties
    
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver,
                navigationController: UINavigationController?,
                transferModel: QRTransferModel) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies(transferModel: transferModel)
    }
    
    // MARK: SetUp
    
    private func setupDependencies(transferModel: QRTransferModel) {
        self.dependenciesEngine.register(for: QRCodeGeneratorProtocol.self) { _ in
            return QRCodeGenerator()
        }
        self.dependenciesEngine.register(for: QRTransferMapping.self) { resolver in
            let qrCodeGenerator = resolver.resolve(for: QRCodeGeneratorProtocol.self)
            return QRTransferMapper(qrGenerator: qrCodeGenerator)
        }
        self.dependenciesEngine.register(for: DropdownPresenter.self) { _ in
            return DropdownViewController()
        }
        self.dependenciesEngine.register(for: SummaryImageSaverProtocol.self) { _ in
            return SummaryImageSaver()
        }
        self.dependenciesEngine.register(for: PhotoLibraryPermissionsManagerProtocol.self) { _ in
            return PhotoLibraryPermissionsManager()
        }
        self.dependenciesEngine.register(for: ScanAndPaySummaryCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: ScanAndPaySummaryPresenterProtocol.self) { resolver in
            return ScanAndPaySummaryPresenter(dependenciesResolver: resolver, transferModel: transferModel)
        }
        
        self.dependenciesEngine.register(for: ScanAndPaySummaryViewController.self) { resolver in
            let presenter = resolver.resolve(for: ScanAndPaySummaryPresenterProtocol.self)
            let viewController = ScanAndPaySummaryViewController(
                presenter: presenter,
                dropdownPresenter: resolver.resolve(for: DropdownPresenter.self))
            presenter.view = viewController
            return viewController
        }
        
    }
    
    // MARK: Methods
    
    func start() {
        let controller = dependenciesEngine.resolve(for: ScanAndPaySummaryViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func close() {
        guard let indexOfScanner = navigationController?.viewControllers.firstIndex(where: { $0 is ScanAndPayScannerViewController }),
                let parentController = navigationController?.viewControllers[safe: indexOfScanner - 1] else {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        navigationController?.popToViewController(parentController, animated: true)
    }
    
    func back(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func handleImageShare(image: UIImage) {
        let itemsToShare = [image]
        let activityController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        navigationController?.present(activityController, animated: true)
    }
}
