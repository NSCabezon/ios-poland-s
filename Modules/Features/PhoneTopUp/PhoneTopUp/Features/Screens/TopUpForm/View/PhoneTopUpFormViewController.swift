//
//  PhoneTopUpFormViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/11/2021.
//

import UI
import PLUI
import PLCommons
import CoreFoundationLib

protocol PhoneTopUpFormViewProtocol: AnyObject, ConfirmationDialogPresentable, LoaderPresentable, ErrorPresentable {
    func updateSelectedAccount(with accountModels: [SelectableAccountViewModel])
    func updatePhoneInput(with phoneNumber: String)
    func updateRecipientName(with name: String)
    func updateContact(with contact: MobileContact)
    func updateOperatorSelection(with gsmOperator: GSMOperator?)
    func updatePaymentAmounts(with cellModels: [PaymentAmountCellViewModel], selectedAmount: TopUpAmount?)
    func updateTermsView(isAcceptanceRequired: Bool, isAccepted: Bool)
    func updateContinueButton(isEnabled: Bool)
    func showInvalidPhoneNumberError(_ showError: Bool)
    func showInvalidCustomAmountError(_ error: String?)
    func showContactsPermissionsDeniedDialog()
}

final class PhoneTopUpFormViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: PhoneTopUpFormPresenterProtocol
    private let mainStackView = UIStackView()
    private let formView = PhoneTopUpFormView()
    private let navigationBarSeparator = UIView()
    private let continueButtonView = BottomButtonView(style: .red)
    
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
        mainStackView.addArrangedSubview(continueButtonView)
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        continueButtonView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBarSeparator.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
        navigationBarSeparator.backgroundColor = .lightSanGray
        continueButtonView.configure(title: localized("generic_button_continue")) { [weak self] in
            self?.presenter.didTouchContinueButton()
        }
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
    
    func updateOperatorSelection(with gsmOperator: GSMOperator?) {
        formView.updateOperatorSelection(with: gsmOperator)
    }
    
    func showContactsPermissionsDeniedDialog() {
        let dialog = ContactsPermissionDeniedDialogBuilder().buildDialog()
        dialog.showIn(self)
    }
    
    func updateRecipientName(with name: String) {
        formView.updateRecipientName(with: name)
    }
    
    func updatePaymentAmounts(with cellModels: [PaymentAmountCellViewModel], selectedAmount: TopUpAmount?) {
        formView.updatePaymentAmounts(with: cellModels, selectedAmount: selectedAmount)
    }
    
    func updateTermsView(isAcceptanceRequired: Bool, isAccepted: Bool) {
        formView.updateTermsView(isAcceptanceRequired: isAcceptanceRequired, isAccepted: isAccepted)
    }
    
    func updateContinueButton(isEnabled: Bool) {
        if isEnabled {
            continueButtonView.enableButton()
        } else {
            continueButtonView.disableButton()
        }
    }
    
    func showInvalidCustomAmountError(_ error: String?) {
        formView.showInvalidCustomAmountError(error)
    }
}

extension PhoneTopUpFormViewController: PhoneTopUpFormViewDelegate {
    func topUpFormDidSelectChangeAccount() {
        presenter.didSelectChangeAccount()
    }
    
    func topUpFormDidTouchContactsButton() {
        presenter.didTouchContactsButton()
    }
    
    func topUpFormDidInputPartialPhoneNumber(_ number: String) {
        presenter.didInputPartialPhoneNumber(number)
    }
    
    func topUpFormDidInputFullPhoneNumber(_ number: String) {
        presenter.didInputFullPhoneNumber(number)
    }
    
    func topUpFormDidSelectTopUpAmount(_ amount: TopUpAmount) {
        presenter.didSelectTopUpAmount(amount)
    }
    
    func updatePhoneInput(with phoneNumber: String) {
        formView.updatePhoneInput(with: phoneNumber)
    }
    
    func updateContact(with contact: MobileContact) {
        formView.updatePhoneInput(with: contact.phoneNumber)
        formView.updateRecipientName(with: contact.fullName)
    }
    
    func topUpFormDidTouchOperatorSelectionButton() {
        presenter.didTouchOperatorSelectionButton()
    }
    
    func topUpFormDidTouchTermsAndConditionsCheckBox() {
        presenter.didTouchTermsAndConditionsCheckBox()
    }
}
