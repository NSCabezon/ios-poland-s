//
//  AddTaxPayerFormViewController.swift
//  TaxTransfer
//
//  Created by 187831 on 02/02/2022.
//

import UI
import PLUI
import IQKeyboardManagerSwift

protocol AddTaxPayerViewDelegate: AnyObject {
    func didTapIdentifiersSelector()
    func didUpdateText()
}

protocol AddTaxPayerFormView: AnyObject,
                              ConfirmationDialogPresentable {
    func clearValidationMessages()
    func getForm() -> AddTaxPayerForm?
    func showInvalidFormMessages(_ messages: InvalidAddTaxPayerFormMessages)
    func setUp(with identifier: Selectable<TaxIdentifierType>)
    func setUp(isEmpty: Bool)
}

final class AddTaxPayerFormViewController: UIViewController {
    weak var delegate: AddTaxPayerViewDelegate?
    
    private let bottomButtonView = BottomButtonView()
    private let formView = AddTaxPayerFormContainerView()
    
    private let presenter: AddTaxPayerPresenterFormProtocol
    
    init(presenter: AddTaxPayerPresenterFormProtocol) {
        self.presenter = presenter
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
        configureKeyboardDismissGesture()
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func setUp(with identifier: Selectable<TaxIdentifierType>) {
        formView.setUp(with: identifier)
    }
    
    func setUp(isEmpty: Bool) {
        if isEmpty {
            bottomButtonView.disableButton()
        } else {
            bottomButtonView.enableButton()
        }
    }
    
    private func setUp() {
        configureStyling()
        configureSubviews()
        configureBottomView()
        configureDelegate()
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: "pl_toolbar_title_Payee"))
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
        bottomButtonView.configure(title: "#Gotowe") {
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

extension AddTaxPayerFormViewController: AddTaxPayerFormViewDelegate {
    func didTapIdentifiersSelector() {
        delegate?.didTapIdentifiersSelector()
    }
    
    func didUpdateText() {
        delegate?.didUpdateText()
    }
}

extension AddTaxPayerFormViewController: AddTaxPayerFormView {
    func getForm() -> AddTaxPayerForm? {
        return formView.getForm()
    }
    
    func showInvalidFormMessages(_ messages: InvalidAddTaxPayerFormMessages) {
        formView.showInvalidFormMessages(messages)
    }
    
    func clearValidationMessages() {
        formView.clearValidationMessages()
        bottomButtonView.enableButton()
    }
}
