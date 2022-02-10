//
//  PhoneTopUpFormView.swift
//  PhoneTopUp
//
//  Created by 188216 on 02/12/2021.
//

import UIKit
import UI
import PLUI
import CoreFoundationLib

protocol PhoneTopUpFormViewDelegate: AnyObject {
    func topUpFormDidSelectChangeAccount()
    func didTouchContactsButton()
    func didTouchOperatorSelectionButton()
    func topUpFormDidInputPartialPhoneNumber(_ number: String)
    func topUpFormDidInputFullPhoneNumber(_ number: String)
    func topUpFormDidSelectTopUpAmount(_ value: TopUpValue?)
}

final class PhoneTopUpFormView: UIView {
    // MARK: Properties
    
    weak var delegate: PhoneTopUpFormViewDelegate?
    private let contentScrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let selectedAccountSectionContainer = UIStackView()
    private let selectedAccountHeaderLabel = FormHeaderLabel()
    private let selectedAccountView = SelectedAccountView()
    private let phoneNumberInputView = PhoneNumberInputView()
    private let recipientNameView = RecipientNameView()
    private let operatorSelectionView = OperatorSelectionView()
    private let amountSelectionView = PaymentAmountSelectionView()
    private let termsAndConditionsView = TermsAndConditionsView()
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    // MARK: Configuration
    
    private func setUp() {
        addSubviews()
        setUpLayout()
        prepareStyles()
        prepareSelectAccountView()
        phoneNumberInputView.delegate = self
        operatorSelectionView.delegate = self
        amountSelectionView.delegate = self
    }

    private func addSubviews() {
        addSubviewConstraintToEdges(contentScrollView)
        
        contentScrollView.addSubviewConstraintToEdges(contentStackView)
        
        contentStackView.addArrangedSubview(selectedAccountSectionContainer)
        contentStackView.addArrangedSubview(phoneNumberInputView)
        contentStackView.addArrangedSubview(recipientNameView)
        contentStackView.addArrangedSubview(operatorSelectionView)
        contentStackView.addArrangedSubview(amountSelectionView)
        contentStackView.addArrangedSubview(termsAndConditionsView)
        
        selectedAccountSectionContainer.addArrangedSubview(selectedAccountHeaderLabel)
        selectedAccountSectionContainer.addArrangedSubview(selectedAccountView)
    }
    
    private func setUpLayout() {
        contentStackView.axis = .vertical
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        contentStackView.spacing = 24.0
        selectedAccountSectionContainer.axis = .vertical
        selectedAccountSectionContainer.spacing = 8.0
        
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
        ])
    }
    
    private func prepareStyles() {
        selectedAccountHeaderLabel.text = localized("pl_topup_text_sendAccount")
        recipientNameView.isHidden = true
        operatorSelectionView.isHidden = true
        amountSelectionView.isHidden = true
        termsAndConditionsView.isHidden = true
    }
    
    private func prepareSelectAccountView() {
        selectedAccountView.setChangeAction { [weak self] in
            self?.delegate?.topUpFormDidSelectChangeAccount()
        }
    }
    
    // MARK: Methods
    
    func updateSelectedAccount(with accountModels: [SelectableAccountViewModel]) {
        selectedAccountView.setViewModel(accountModels)
    }
    
    func showInvalidPhoneNumberError(_ showError: Bool) {
        phoneNumberInputView.showInvalidPhoneNumberError(showError)
        updateOperatorSelection(with: nil)
    }
    
    func updateOperatorSelection(with gsmOperator: GSMOperator?) {
        operatorSelectionView.setUp(with: gsmOperator)
    }
    
    func updatePhoneInput(with phoneNumber: String) {
        phoneNumberInputView.updatePhoneInput(with: phoneNumber)
    }
    
    func updateRecipientName(with name: String) {
        recipientNameView.setUp(with: name)
        recipientNameView.isHidden = name.isEmpty
    }
    
    func updatePaymentAmounts(with values: TopUpValues?, selectedValue: TopUpValue?) {
        amountSelectionView.setUp(with: values, selectedValue: selectedValue)
    }
}

extension PhoneTopUpFormView: PhoneNumberInputViewDelegate {
    func didInputPartialPhoneNumber(_ number: String) {
        delegate?.topUpFormDidInputPartialPhoneNumber(number)
    }

    func didInputFullPhoneNumber(_ number: String) {
        delegate?.topUpFormDidInputFullPhoneNumber(number)
    }
    
    func didTouchContactsButton() {
        delegate?.didTouchContactsButton()
    }
}

extension PhoneTopUpFormView: OperatorSelectionViewDelegate {
    func didTouchOperatorSelectionButton() {
        delegate?.didTouchOperatorSelectionButton()
    }
}

extension PhoneTopUpFormView: PaymentAmontSelectionViewDelegate {
    func didSelectTopUpValue(_ value: TopUpValue?) {
        delegate?.topUpFormDidSelectTopUpAmount(value)
    }
}
