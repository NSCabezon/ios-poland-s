//
//  ScanAndPayScannerPresenter.swift
//  ScanAndPay
//
//  Created by 188216 on 16/03/2022.
//

import Foundation
import CoreFoundationLib

protocol ScanAndPayScannerPresenterProtocol: AnyObject {
    var view: ScanAndPayScannerViewProtocol? { get set }
    func viewDidAppear()
    func didSelectBack()
    func didInitializeScanner()
    func didFailToInitializeScanner()
}

final class ScanAndPayScannerPresenter {
    // MARK: Properties
    weak var view: ScanAndPayScannerViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: ScanAndPayScannerCoordinatorProtocol?
    private lazy var cameraPermissionsManager = dependenciesResolver.resolve(for: CameraPermissionsManagerProtocol.self)
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
        self.coordinator = dependenciesResolver.resolve(for: ScanAndPayScannerCoordinatorProtocol.self)
    }
}

extension ScanAndPayScannerPresenter: ScanAndPayScannerPresenterProtocol {
    func viewDidAppear() {
        cameraPermissionsManager.requestCameraPermissions { [weak self] authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                self?.view?.initializeScanner()
            case .deniedForTheFirstTime:
                self?.coordinator?.back(animated: true)
            case .denied:
                self?.showPermissionsDeniedDialog()
            }
        }
    }
    
    func didSelectBack() {
        coordinator?.back(animated: true)
    }
    
    func didInitializeScanner() {
        view?.startScanning()
    }
    
    func didFailToInitializeScanner() {
        #warning("Add localized text")
        view?.showErrorMessage("#Failed to initialize scanner", onConfirm: { [weak self] in
            self?.coordinator?.back(animated: true)
        })
    }
}

private extension ScanAndPayScannerPresenter {
    func showPermissionsDeniedDialog() {
        let permissionsDeniedDialog = CameraPermissionsDeniedDialogBuilder().buildDialog { [weak self] in
            self?.coordinator?.back(animated: false)
        }
        view?.showDialog(permissionsDeniedDialog)
    }
}
