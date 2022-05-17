//
//  TaxTransferBillingPeriodViewController.swift
//  TaxTransfer
//
//  Created by 187831 on 03/03/2022.
//

import UI
import PLUI
import CoreFoundationLib
import IQKeyboardManagerSwift

protocol TaxTransferFormBillingPeriodFormViewDelegate: AnyObject {
    func didTapPeriodType()
    func didTapPeriodNumber()
    func didUpdateText()
}

protocol TaxTransferFormBillingPeriodFormView: AnyObject,
                                       ConfirmationDialogPresentable {
    func clearValidationMessages()
    func disableBottomButton()
    func setUp(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxBillingPeriodViewModel>
    )
    func setUp(periodNumber: Selectable<Int>)
    func showInvalidFormMessages(_ messages: InvalidTaxBillingPeriodFormMessage)
    func getForm() -> TaxTransferBillingPeriodForm?
}

final class TaxTransferBillingPeriodViewController: UIViewController {
    private weak var delegate: TaxTransferFormBillingPeriodFormViewDelegate?
    private let presenter: TaxTransferBillingPeriodPresenter
    private let bottomButtonView = BottomButtonView()
    private let formView = TaxTransferBillingPeriodContainerView()
    
    init(presenter: TaxTransferBillingPeriodPresenter,
         delegate: TaxTransferFormBillingPeriodFormViewDelegate?) {
        self.presenter = presenter
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationItem()
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    private func setUp() {
        configureStyling()
        configureSubviews()
        configureBottomView()
        configureDelegate()
        configureKeyboardDismissGesture(shouldCancelTouchesInView: false)
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: "pl_toolbar_title_settlementPeriod"))
            .setLeftAction(.back(action: .selector(#selector(back))))
            .setRightActions(.close(action: .selector(#selector(close))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func configureStyling() {
        view.backgroundColor = .white
    }
    
    private func configureSubviews() {
        [formView, bottomButtonView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            formView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            formView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            bottomButtonView.heightAnchor.constraint(equalToConstant: 70),
            bottomButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureBottomView() {
        bottomButtonView.disableButton()
        bottomButtonView.configure(title: localized("pl_generic_button_done")) {
            self.presenter.didTapDone()
        }
    }
    
    private func configureDelegate() {
        formView.delegate = self
    }
    
    @objc private func back() {
        presenter.didPressBack()
    }
    
    @objc private func close() {
        presenter.didPressClose()
    }
}

extension TaxTransferBillingPeriodViewController: TaxTransferBillingPeriodFormDelegate {
    func didTapPeriodType() {
        delegate?.didTapPeriodType()
    }
    
    func didTapPeriodNumber() {
        delegate?.didTapPeriodNumber()
    }
    
    func didUpdateText() {
        delegate?.didUpdateText()
    }
}

extension TaxTransferBillingPeriodViewController: TaxTransferFormBillingPeriodFormView {
    func disableBottomButton() {
        bottomButtonView.disableButton()
    }
    
    func clearValidationMessages() {
        formView.clearValidationMessages()
        bottomButtonView.enableButton()
    }
    
    func showInvalidFormMessages(_ messages: InvalidTaxBillingPeriodFormMessage) {
        formView.showInvalidFormMessages(messages)
        bottomButtonView.disableButton()
    }
    
    func setUp(with viewModel: Selectable<TaxTransferFormViewModel.TaxBillingPeriodViewModel>) {
        formView.setUp(with: viewModel, onTap: didTapPeriodType)
    }
    
    func setUp(periodNumber: Selectable<Int>) {
        formView.setUp(with: periodNumber, onTap: didTapPeriodNumber)
    }
    
    func getForm() -> TaxTransferBillingPeriodForm? {
        return formView.getForm()
    }
}
