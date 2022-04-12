//
//  ScanAndPayScannerPresenter.swift
//  ScanAndPay
//
//  Created by 188216 on 16/03/2022.
//

import Foundation
import CoreFoundationLib
import PLCommons

protocol ScanAndPayScannerPresenterProtocol: AnyObject {
    var view: ScanAndPayScannerViewProtocol? { get set }
    func viewDidAppear()
    func didSelectBack()
    func didInitializeScanner()
    func didFailToInitializeScanner()
    func didSelectGallery()
    func didSelectImage(_ image: UIImage?)
    func didCaptureCode(_ code: String)
}

final class ScanAndPayScannerPresenter {
    // MARK: Properties
    weak var view: ScanAndPayScannerViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private var coordinator: ScanAndPayScannerCoordinatorProtocol?
    private let qrCodeParser = QRTransferParser()
    private lazy var cameraPermissionsManager = dependenciesResolver.resolve(for: CameraPermissionsManagerProtocol.self)
    private lazy var qrCodeDetector = dependenciesResolver.resolve(for: QRCodeDetectorProtocol.self)
    private lazy var preferencesStore = dependenciesResolver.resolve(for: PreferencesStoreProtocol.self)
    
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
        if preferencesStore.isScannerShownForTheFirstTime {
            view?.showInfoTooltip()
            preferencesStore.isScannerShownForTheFirstTime = false
        } else {
            view?.startScanning()
        }
    }
    
    func didFailToInitializeScanner() {
        view?.showErrorMessage(localized("pl_scanAndPay_errorText_cameraError"), onConfirm: { [weak self] in
            self?.coordinator?.back(animated: true)
        })
    }
    
    func didSelectGallery() {
        view?.showImagePicker()
    }
    
    func didSelectImage(_ image: UIImage?) {
        guard let image = image, let detectedCode = qrCodeDetector.detectQrCodes(in: image).first else {
            view?.showUnrecognizedCodeDialog()
            view?.startScanning()
            return
        }
        
        handleCodeDetection(code: detectedCode)
    }
    
    func didCaptureCode(_ code: String) {
        handleCodeDetection(code: code)
    }
}

private extension ScanAndPayScannerPresenter {
    func showPermissionsDeniedDialog() {
        let permissionsDeniedDialog = CameraPermissionsDeniedDialogBuilder().buildDialog { [weak self] in
            self?.coordinator?.back(animated: false)
        }
        view?.showDialog(permissionsDeniedDialog)
    }
    
    func handleCodeDetection(code: String) {
        view?.stopScanning()
        guard let transferModel = qrCodeParser.parse(string: code) else {
            view?.showUnrecognizedCodeDialog()
            view?.startScanning()
            return
        }
        
        showSummary(with: transferModel)
    }
    
    func showSummary(with transferModel: QRTransferModel) {
        view?.stopScanning()
        #warning("todo: show summary, will be implemented in another PR")
    }
}
