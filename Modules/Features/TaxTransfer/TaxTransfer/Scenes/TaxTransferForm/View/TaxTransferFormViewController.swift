//
//  TaxTransferFormViewController.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

import CoreFoundationLib
import PLCommons
import UI
import PLUI

protocol TaxTransferFormView: AnyObject, LoaderPresentable, ErrorPresentable {
    func setViewModel(_ viewModel: TaxTransferFormViewModel)
    func disableDoneButton(with messages: TaxTransferFormValidity.InvalidFormMessages)
    func enableDoneButton()
    func getCurrentFormFields() -> TaxTransferFormFields
}

final class TaxTransferFormViewController: UIViewController {
    private let presenter: TaxTransferFormPresenterProtocol
    internal let keyboardManager = KeyboardManager()
    private let scrollView = UIScrollView()
    private let bottomButtonView = BottomButtonView()
    private lazy var formView = TaxTransferFormContainerView(
        configuration: presenter.getTaxFormConfiguration(),
        delegate: self
    )

    init(presenter: TaxTransferFormPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
}

extension TaxTransferFormViewController: TaxTransferFormView {
    func setViewModel(_ viewModel: TaxTransferFormViewModel) {
        DispatchQueue.main.async {
            self.formView.configureAccountSelector(with: viewModel.account) { [weak self] in
                self?.presenter.didTapAccountSelector()
            }
            
            self.formView.configureTaxPayerSelector(with: viewModel.taxPayer) { [weak self] in
                self?.presenter.didTapTaxPayer()
            }
            
            self.formView.configureTaxBillingPeriodSelector(with: viewModel.billingPeriod) { [weak self] in
                self?.presenter.didTapBillingPeriod()
            }
            
            self.formView.configureTaxAuthoritySelector(with: viewModel.taxAuthority) { [weak self] in
                self?.presenter.didTapTaxAuthority()
            }
            
            self.formView.configureAmountField(with: viewModel.sendAmount)
            self.formView.configureObligationIdentifierField(with: viewModel)
        }
    }
    
    func disableDoneButton(with messages: TaxTransferFormValidity.InvalidFormMessages) {
        bottomButtonView.disableButton()
        formView.setInvalidFormMessages(messages)
    }
    
    func enableDoneButton() {
        bottomButtonView.enableButton()
        formView.clearInvalidFormMessages()
    }
    
    func getCurrentFormFields() -> TaxTransferFormFields {
        return formView.getFormFields()
    }
}

private extension TaxTransferFormViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureBottomView()
        configureKeyboardManager()
        configureStyling()
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "pl_toolbar_title_taxTransfer"))
            .setLeftAction(.back(action: #selector(back)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(formView)
        view.addSubview(bottomButtonView)
        
        [scrollView, formView, bottomButtonView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            formView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            formView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            formView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bottomButtonView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureKeyboardManager() {
        keyboardManager.setDelegate(self)
        keyboardManager.update()
    }
    
    func configureBottomView() {
        bottomButtonView.disableButton()
        bottomButtonView.configure(title: localized("pl_generic_button_done")) { [weak self] in
            guard let data = self?.formView.getFormFields() else { return }
            self?.presenter.didTapDone(with: data)
        }
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    @objc func back() {
        presenter.didTapBack()
    }
}

extension TaxTransferFormViewController: KeyboardManagerDelegate {
    var associatedScrollView: UIScrollView? {
        return scrollView
    }
}

extension TaxTransferFormViewController: TaxTransferFormContainerViewDelegate {
    func scrollToBottom() {
        let bottomOffset = CGPoint(
            x: 0,
            y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom
        )
        if (bottomOffset.y > 0) {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func didUpdateFields(withFields fields: TaxTransferFormFields) {
        presenter.didUpdateFields(with: fields)
    }
}
