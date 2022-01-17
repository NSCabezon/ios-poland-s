//
//  PhoneTopUpFormViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/11/2021.
//

import UI
import PLUI
import PLCommons
import Commons

protocol PhoneTopUpFormViewProtocol: AnyObject, ConfirmationDialogPresentable {
    func updateSelectedAccount(with accountModels: [SelectableAccountViewModel])
    func updatePhoneInput(with phoneNumber: String)
    func updateContact(with contact: MobileContact)
    func showInvalidPhoneNumberError(_ showError: Bool)
    func showOperatorSelection(with operator: Operator?)
    func showContactsPermissionsDeniedDialog()
}

final class PhoneTopUpFormViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: PhoneTopUpFormPresenterProtocol
    private let mainStackView = UIStackView()
    private let formView = PhoneTopUpFormView()
    private let navigationBarSeparator = UIView()
    private let bottomButtonView = BottomButtonView(style: .red)
    
    // MARK: Lifecycle
    
    init(presenter: PhoneTopUpFormPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    // MARK: Configuration
    
    private func setUp() {
        prepareNavigationBar()
        addSubviews()
        setUpLayout()
        prepareStyles()
        formView.delegate = self
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("pl_topup_title_topup")))
            .setLeftAction(.back(action: #selector(goBack)))
            .setRightActions(.close(action: #selector(closeProcess)))
            .build(on: self, with: nil)
    }
    
    private func addSubviews() {
        view.addSubviewsConstraintToSafeAreaEdges(mainStackView)
        mainStackView.addArrangedSubview(navigationBarSeparator)
        mainStackView.addArrangedSubview(formView)
        mainStackView.addArrangedSubview(bottomButtonView)
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        bottomButtonView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBarSeparator.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
        navigationBarSeparator.backgroundColor = .lightSanGray
        bottomButtonView.configure(title: localized("generic_button_continue")) {
            // TODO: Add ready botton action
        }
        bottomButtonView.disableButton()
    }
    
    // MARK: Actions
    
    @objc private func goBack() {
        presenter.didSelectBack()
    }
    
    @objc private func closeProcess() {
        presenter.didSelectClose()
    }
}

extension PhoneTopUpFormViewController: PhoneTopUpFormViewProtocol {
    func updateSelectedAccount(with accountModels: [SelectableAccountViewModel]) {
        formView.updateSelectedAccount(with: accountModels)
    }
    
    func showInvalidPhoneNumberError(_ showError: Bool) {
        formView.showInvalidPhoneNumberError(showError)
    }
    
    func showOperatorSelection(with mobileOperator: Operator?) {
        formView.showOperatorSelection(with: mobileOperator)
    }
    
    func showContactsPermissionsDeniedDialog() {
        let dialog = ContactsPermissionDeniedDialogBuilder().buildDialog()
        dialog.showIn(self)
    }
}

extension PhoneTopUpFormViewController: PhoneTopUpFormViewDelegate {
    func topUpFormDidSelectChangeAccount() {
        presenter.didSelectChangeAccount()
    }
    
    func didTouchContactsButton() {
        presenter.didTouchContactsButton()
    }
    
    func topUpFormDidInputPartialPhoneNumber(_ number: String) {
        presenter.didInputPartialPhoneNumber(number)
    }
    
    func topUpFormDidInputFullPhoneNumber(_ number: String) {
        presenter.didInputFullPhoneNumber(number)
    }
    
    func updatePhoneInput(with phoneNumber: String) {
        formView.updatePhoneInput(with: phoneNumber)
    }
    
    func updateContact(with contact: MobileContact) {
        formView.updatePhoneInput(with: contact.phoneNumber)
        formView.updateRecipientName(with: contact.fullName)
    }
}
