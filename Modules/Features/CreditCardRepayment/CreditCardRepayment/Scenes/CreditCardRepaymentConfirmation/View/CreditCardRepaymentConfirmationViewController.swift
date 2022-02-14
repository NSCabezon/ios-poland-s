//
//  CreditCardRepaymentConfirmationViewController.swift
//  CreditCardRepayment
//
//  Created by 186484 on 08/07/2021.
//

import UIKit
import Operative
import UI
import CoreFoundationLib

protocol CreditCardRepaymentConfirmationViewProtocol: OperativeConfirmationViewProtocol {
    func showErrorDialog()
}

class CreditCardRepaymentConfirmationViewController: OperativeConfirmationViewController {
    
    let presenter: CreditCardRepaymentConfirmationPresenterProtocol
    
    init(presenter: CreditCardRepaymentConfirmationPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        operativeViewWillDisappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
}

extension CreditCardRepaymentConfirmationViewController: CreditCardRepaymentConfirmationViewProtocol {
    func showErrorDialog() {
        let errorDialog = CreditCardRepaymentConfirmationDialogFactory.makeErrorDialog()
        errorDialog.showIn(self)
    }
}

private extension CreditCardRepaymentConfirmationViewController {
    
    func setupNavigationBar() {
        NavigationBarBuilder(style: .sky, title: .title(key: localized("genericToolbar_title_confirmation")))
            .setRightActions(.close(action: #selector(didSelectClose)))
            .build(on: self, with: nil)
    }
    
    @objc func didSelectClose() {
        let dialog = CreditCardRepaymentDetailsDialogFactory.makeCloseDialog(
            onAccept: { [weak self] in
                self?.presenter.didConfirmClosing()
            }
        )
        dialog.showIn(self)
    }
    
}

