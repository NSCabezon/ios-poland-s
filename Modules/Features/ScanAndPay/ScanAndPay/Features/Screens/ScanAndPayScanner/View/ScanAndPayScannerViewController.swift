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

protocol ScanAndPayScannerViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable, ConfirmationDialogPresentable {
    func initializeScanner()
    func startScanning()
    func stopScanning()
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
    
    // MARK: Configuration
    
    private func setUp() {
        prepareNavigationBar()
        prepareStyles()
        setUpScannerView()
    }
    
    private func prepareNavigationBar() {
        #warning("change text")
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("Scan and Pay")))
            .setLeftAction(.back(action: .selector(#selector(goBack))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
    }
    
    private func setUpScannerView() {
        view.addSubviewConstraintToEdges(scannerView)
    }
    
    // MARK: Actions
    
    @objc private func goBack() {
        presenter.didSelectBack()
    }
}

extension ScanAndPayScannerViewController: ScanAndPayScannerViewProtocol {
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
}
