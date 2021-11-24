//
//  CreditCardRepaymentDetailsViewController.swift
//  Pods
//
//  Created by 186490 on 01/06/2021.
//

import Commons
import Foundation
import UI
import Operative

protocol CreditCardRepaymentDetailsViewModelSetupProtocol {
    func setupAccountTypeInfo(with viewModel: CreditCardRepaymentDetailsAccountInfoViewModel)
    func setupRepaymentTypeInfo(with viewModel: CreditCardRepaymentDetailsRepaymentTypeInfoViewModel)
    func setupRepaymentAmount(with viewModel: CreditCardRepaymentDetailsRepaymentAmountViewModel)
    func setupDateInfo(with viewModel: CreditCardRepaymentDateInfoViewModel)
    func setupNext(with viewModel: CreditCardRepaymentDetailsNextViewModel)
    func setupEditHeader(with viewModel: CreditCardRepaymentDetailsEditHeaderViewModel)
}

protocol CreditCardRepaymentDetailsViewProtocol: OperativeView, CreditCardRepaymentDetailsViewModelSetupProtocol {
    func showMinimumAmountDialog()
    func showConfirmAbandonChangesDialog(onAccept: @escaping () -> Void)
}

final class CreditCardRepaymentDetailsViewController: UIViewController {
    private let presenter: CreditCardRepaymentDetailsPresenterProtocol
    private lazy var contentView = CreditCardRepaymentDetailsView()
    
    init(presenter: CreditCardRepaymentDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        contentView.configureKeyboard()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        contentView.addKeyboardObserver()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.operativeViewWillDisappear()
    }
    
    func setupNavigationBar() {
        NavigationBarBuilder(style: .sky,
                             title: .title(key: localized("pl_creditCard_title_creditCardRepay")))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .setRightActions(.close(action: #selector(didSelectClose)))
            .build(on: self, with: self.presenter)
    }
    
    func showMinimumAmountDialog() {
        let minimumAmountDialog = CreditCardRepaymentDetailsDialogFactory.makeMinimumAmountDialog()
        minimumAmountDialog.showIn(self)
    }
    
    func showConfirmAbandonChangesDialog(onAccept: @escaping () -> Void) {
        let builder = CreditCardRepaymentDetailsDialogFactory.makeConfirmAbandonChangesDialog(onAccept: onAccept)
        builder.showIn(self)
    }
}

private extension CreditCardRepaymentDetailsViewController {
    @objc func didSelectClose() {
        let dialog = CreditCardRepaymentDetailsDialogFactory.makeCloseDialog(
            onAccept: { [weak self] in
                self?.presenter.didConfirmClosing()
            }
        )
        dialog.showIn(self)
    }
    
    @objc private func didSelectBack() {
        view.endEditing(true)
        presenter.backButtonSelected()
    }
}

extension CreditCardRepaymentDetailsViewController: CreditCardRepaymentDetailsViewProtocol {
    
    var operativePresenter: OperativeStepPresenterProtocol {
        presenter
    }
    
    func setupAccountTypeInfo(with viewModel: CreditCardRepaymentDetailsAccountInfoViewModel) {
        contentView.setupAccountTypeInfo(with: viewModel)
    }
    
    func setupRepaymentTypeInfo(with viewModel: CreditCardRepaymentDetailsRepaymentTypeInfoViewModel) {
        contentView.setupRepaymentTypeInfo(with: viewModel)
    }
    
    func setupRepaymentAmount(with viewModel: CreditCardRepaymentDetailsRepaymentAmountViewModel) {
        contentView.setupRepaymentAmount(with: viewModel)
    }
    
    func setupDateInfo(with viewModel: CreditCardRepaymentDateInfoViewModel) {
        contentView.setupDateInfo(with: viewModel)
    }
    
    func setupNext(with viewModel: CreditCardRepaymentDetailsNextViewModel) {
        contentView.setupNext(with: viewModel)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupEditHeader(with viewModel: CreditCardRepaymentDetailsEditHeaderViewModel) {
        contentView.setupEditHeader(with: viewModel)
    }
    
}
