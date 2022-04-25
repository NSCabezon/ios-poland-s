//
//  AddTaxAuthorityViewController.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import UI
import PLUI
import CoreFoundationLib

protocol AddTaxAuthorityView: AnyObject, LoaderPresentable, ErrorPresentable, ConfirmationDialogPresentable {
    func setViewModel(_ viewModel: AddTaxAuthorityViewModel)
    func setDoneButtonState(isEnabled: Bool)
    func setInvalidFormMessages(_ messages: InvalidTaxAuthorityFormFormMessages)
    func clearInvalidFormMessages()
}

final class AddTaxAuthorityViewController: UIViewController {
    private let presenter: AddTaxAuthorityPresenterProtocol
    private let scrollView = UIScrollView()
    private let bottomButtonView = BottomButtonView()
    private lazy var formView = AddTaxAuthorityContainerView(delegate: self)
    
    let keyboardManager = KeyboardManager()

    init(presenter: AddTaxAuthorityPresenterProtocol) {
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

extension AddTaxAuthorityViewController: AddTaxAuthorityView {
    func setViewModel(_ viewModel: AddTaxAuthorityViewModel) {
        DispatchQueue.main.async {
            switch viewModel {
            case .taxSymbolSelector:
                self.setTaxSymbolSelectorState()
            case let .usForm(viewModel):
                self.setUsFormState(with: viewModel)
            case let .irpForm(viewModel):
                self.setIrpFormState(with: viewModel)
            }
        }
    }
    
    func setDoneButtonState(isEnabled: Bool) {
        DispatchQueue.main.async {
            isEnabled ? self.bottomButtonView.enableButton() : self.bottomButtonView.disableButton()
        }
    }
    
    func setInvalidFormMessages(_ messages: InvalidTaxAuthorityFormFormMessages) {
        DispatchQueue.main.async {
            self.formView.showInvalidFormMessages(messages)
        }
    }
    
    func clearInvalidFormMessages() {
        DispatchQueue.main.async {
            self.formView.clearInvalidFormMessages()
        }
    }
    
    private func setTaxSymbolSelectorState() {
        formView.showTaxSymbolSelector(onTaxSymbolTap: { [weak self] in
            self?.presenter.didTapTaxSymbolSelector()
        })
    }
    
    private func setUsFormState(with viewModel: AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel) {
        formView.showUsForm(
            viewModel: viewModel,
            onTaxSymbolTap: { [weak self] in
                self?.presenter.didTapTaxSymbolSelector()
            },
            onCityTap: { [weak self] in
                self?.presenter.didTapCitySelector()
            },
            onTaxAuthorityTap: { [weak self] in
                self?.presenter.didTapTaxAuthoritySelector()
            }
        )
    }
    
    private func setIrpFormState(with viewModel: AddTaxAuthorityViewModel.IrpTaxAuthorityFormViewModel) {
        formView.showIrpForm(
            viewModel: viewModel,
            onTaxSymbolTap: { [weak self] in
                self?.presenter.didTapTaxSymbolSelector()
            }
        )
    }
}

private extension AddTaxAuthorityViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureBottomView()
        configureKeyboardManager()
        configureStyling()
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "pl_toolbar_taxAuthority"))
            .setLeftAction(.back(action: .selector(#selector(back))))
            .setRightActions(.close(action: .selector(#selector(close))))
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
        bottomButtonView.configure(title: localized("generic_label_done")) { [weak self] in
            self?.presenter.didTapDone()
        }
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    @objc func back() {
         presenter.didTapBack()
    }
    
    @objc func close() {
        presenter.didTapClose()
    }
}

extension AddTaxAuthorityViewController: KeyboardManagerDelegate {
    var associatedScrollView: UIScrollView? {
        return scrollView
    }
}

extension AddTaxAuthorityViewController: AddTaxAuthorityContainerViewDelegate {
    func didUpdateFields(
        taxAuthorityName: String?,
        accountNumber: String?
    ) {
        presenter.didUpdateIrpFields(
            taxAuthorityName: taxAuthorityName,
            accountNumber: accountNumber
        )
    }
}

