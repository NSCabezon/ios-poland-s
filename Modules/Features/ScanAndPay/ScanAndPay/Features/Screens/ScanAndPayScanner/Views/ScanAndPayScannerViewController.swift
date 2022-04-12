//
//  ScanAndPayScannerViewController.swift
//  ScanAndPay
//
//  Created by 188216 on 16/03/2022.
//

import CoreFoundationLib
import UI
import PLUI
import PLCommons
import CoreServices

protocol ScanAndPayScannerViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable, ConfirmationDialogPresentable {
    func showInfoTooltip()
    func initializeScanner()
    func startScanning()
    func stopScanning()
    func showImagePicker()
    func showUnrecognizedCodeDialog()
}

final class ScanAndPayScannerViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: ScanAndPayScannerPresenterProtocol
    private let scannerView = BarcodeScannerView()
    
    // MARK: Lifecycle
    
    init(presenter: ScanAndPayScannerPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanning()
    }
    
    // MARK: Configuration
    
    private func setUp() {
        prepareNavigationBar()
        prepareStyles()
        setUpViews()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .tooltip(
                titleKey: localized("pl_scanAndPay_toolbar"),
                type: .red,
                action: { [weak self] sender in
                    self?.showTooltip(from: sender)
                }
            )
        )
            .setLeftAction(.back(action: .selector(#selector(goBack))))
            .setRightActions(.image(image: "icnImageGallery", action: .selector(#selector(imageGalleryTouched))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
    }
    
    private func setUpViews() {
        scannerView.delegate = self
        view.addSubview(scannerView)
        scannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    // MARK: Actions
    
    @objc private func goBack() {
        presenter.didSelectBack()
    }
    
    @objc private func imageGalleryTouched() {
        presenter.didSelectGallery()
    }
    
    @objc private func showTooltip(from sender: UIView) {
        stopScanning()
        let navigationToolTip = ScanAndPayInfoToolTip()
        navigationToolTip.show(in: self, from: sender, completion: { [weak self] in
            self?.startScanning()
        })
    }
}

extension ScanAndPayScannerViewController: ScanAndPayScannerViewProtocol {
    func showInfoTooltip() {
        guard let titleView = navigationItem.titleView else {
            return
        }
        showTooltip(from: titleView)
    }
    
    func initializeScanner() {
        do {
            try scannerView.initializerScanner()
            presenter.didInitializeScanner()
        } catch {
            presenter.didFailToInitializeScanner()
        }
    }
    
    func startScanning() {
        scannerView.startScanning()
    }
    
    func stopScanning() {
        scannerView.stopScanning()
    }
    
    func showImagePicker() {
        stopScanning()
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = [String(kUTTypeImage)]
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func showUnrecognizedCodeDialog() {
        let infoDialog = InfoDialogBuilder(
            title: .plain(text: localized("pl_scanAndPay_errorTitle_codeUnrecognized")),
            description: .plain(text: localized("pl_scanAndPay_errorText_codeUnrecognized")),
            image: PLAssets.image(named: "info_black") ?? UIImage(),
            buttontTapAction: {}
        ).build()
        infoDialog.showIn(self)
    }
}

extension ScanAndPayScannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as? UIImage
        presenter.didSelectImage(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        startScanning()
    }
}

extension ScanAndPayScannerViewController: BarcodeScannerViewDelegate {
    func scannerView(_ view: BarcodeScannerView, didCaptureCode code: String) {
        presenter.didCaptureCode(code)
    }
}
