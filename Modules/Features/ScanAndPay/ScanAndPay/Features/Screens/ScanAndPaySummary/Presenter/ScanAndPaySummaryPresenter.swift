//
//  ScanAndPaySummaryPresenter.swift
//  ScanAndPay
//
//  Created by 188216 on 07/04/2022.
//

import Foundation
import CoreFoundationLib
import PLCommons
import SANPLLibrary

protocol ScanAndPaySummaryPresenterProtocol: AnyObject {
    var view: ScanAndPaySummaryViewProtocol? { get set }
    func viewDidLoad()
    func didSelectBack()
    func handleSaveTouch(with image: UIImage?)
    func handleShareTouch(with image: UIImage?)
    
}

final class ScanAndPaySummaryPresenter {
    // MARK: Properties
    weak var view: ScanAndPaySummaryViewProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let transferModel: QRTransferModel
    private var coordinator: ScanAndPaySummaryCoordinatorProtocol?
    private lazy var customerManager = dependenciesResolver.resolve(for: PLManagersProviderProtocol.self).getCustomerManager()
    private lazy var photoLibraryHelper = dependenciesResolver.resolve(for: PhotoLibraryPermissionsManagerProtocol.self)
    private lazy var qrTransferMapper = dependenciesResolver.resolve(for: QRTransferMapping.self)
    private lazy var imageSaver = dependenciesResolver.resolve(for: SummaryImageSaverProtocol.self)
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver, transferModel: QRTransferModel) {
        self.dependenciesResolver = dependenciesResolver
        self.transferModel = transferModel
        self.coordinator = dependenciesResolver.resolve(for: ScanAndPaySummaryCoordinatorProtocol.self)
    }
}

extension ScanAndPaySummaryPresenter: ScanAndPaySummaryPresenterProtocol {
    func viewDidLoad() {
        guard let customer = try? customerManager.getIndividual().get(),
              let activeContext = customer.customerContexts?.first(where: { $0.selected ?? false })?.type,
                activeContext == .INDIVIDUAL || activeContext == .MINI_COMPANY else {
            #warning("todo: localize text")
            view?.showErrorMessage(localized("# zły użytkownik"), onConfirm: { [weak self] in
                self?.coordinator?.close()
            })
            return
        }
        
        let isInCompanyContext = activeContext != .INDIVIDUAL
        let summaryViewModel = qrTransferMapper.map(model: transferModel, isInCompanyContext: isInCompanyContext)
        view?.configure(with: summaryViewModel)
    }

    func didSelectBack() {
        coordinator?.back(animated: true)
    }
    
    func handleSaveTouch(with image: UIImage?) {
        guard let image = image else {
            view?.showErrorMessage(localized("generic_error_txt"), onConfirm: nil)
            return
        }
        
        photoLibraryHelper.requestPhotoLibraryPermissions { [weak self] status in
            switch status {
            case .authorized:
                self?.saveImage(image)
            case .denied:
                self?.showPermissionsDeniedDialog()
            }
        }
    }
    
    func handleShareTouch(with image: UIImage?) {
        guard let image = image else {
            view?.showErrorMessage(localized("generic_error_txt"), onConfirm: nil)
            return
        }
        
        coordinator?.handleImageShare(image: image)
    }
}

private extension ScanAndPaySummaryPresenter {
    func saveImage(_ image: UIImage) {
        imageSaver.saveSummaryImage(image) { [weak self] error in
            if error != nil {
                self?.view?.showErrorMessage(localized("generic_error_txt"), onConfirm: nil)
            }
        }
    }
    
    func showPermissionsDeniedDialog() {
        let permissionsDeniedDialog = CameraPermissionsDeniedDialogBuilder().buildDialog { }
        view?.showDialog(permissionsDeniedDialog)
    }
}
