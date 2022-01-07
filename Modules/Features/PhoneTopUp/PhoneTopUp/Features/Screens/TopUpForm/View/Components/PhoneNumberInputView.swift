//
//  PhoneNumberInputView.swift
//  PhoneTopUp
//
//  Created by 188216 on 29/11/2021.
//

import UI
import UIKit
import PLUI
import Commons
import PLCommons

protocol PhoneNumberInputViewDelegate: AnyObject {
    func didTouchContactsButton()
    func didInputPartialPhoneNumber(_ number: String)
    func didInputFullPhoneNumber(_ number: String)
}

final class PhoneNumberInputView: UIView {
    // MARK: Views
    
    private let mainContainer = UIStackView()
    private let headerLabel = FormHeaderLabel()
    private let lisboaPhoneNumberTextField = LisboaTextFieldWithErrorView()
    
    // MARK: Properties
    
    weak var delegate: PhoneNumberInputViewDelegate?
    private let phoneNumberValidator = PartialPhoneNumberValidator()
    private let phoneNumberFormatter = PartialPhoneNumberFormatter()
    private let phoneNumberPrefix = "+48 "

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Configuration
    
    private func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(mainContainer)
        mainContainer.addArrangedSubview(headerLabel)
        mainContainer.addArrangedSubview(lisboaPhoneNumberTextField)
        lisboaPhoneNumberTextField.textField.fieldDelegate = self
    }
    
    private func prepareStyles() {
        headerLabel.text = localized("pl_topup_text_recipPhoneNumb")
        
        lisboaPhoneNumberTextField.setHeight(48.0)
        lisboaPhoneNumberTextField.textField.setRightAccessory(.uiImage(Images.Form.contactIcon, action: { [weak self] in
            self?.delegate?.didTouchContactsButton()
        }))
        lisboaPhoneNumberTextField.textField.setText(phoneNumberPrefix)
    }
    
    private func setUpLayout() {
        mainContainer.axis = .vertical
        mainContainer.spacing = 8.0
    }
    
    // MARK: Methods
    
    func showInvalidPhoneNumberError(_ showError: Bool) {
        if showError {
            lisboaPhoneNumberTextField.showError(localized("pl_topup_text_valid_wrongNumb"))
        } else {
            lisboaPhoneNumberTextField.hideError()
        }
    }
    
    func updatePhoneInput(with phoneNumber: String) {
        let formattedPhoneNumber = phoneNumberPrefix + phoneNumberFormatter.formatPhoneNumberText(phoneNumber)
        lisboaPhoneNumberTextField.textField.setText(formattedPhoneNumber)
    }
}

extension PhoneNumberInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text, let range = Range(range, in: currentText) else {
            return true
        }
        
        let newPhoneNumber = currentText
            .replacingCharacters(in: range, with: string)
            .replace(phoneNumberPrefix, "")
        
        switch phoneNumberValidator.validatePhoneNumberText(newPhoneNumber) {
        case .invalid:
            break
        case .partiallyValid(number: let number):
            textField.text = phoneNumberPrefix + phoneNumberFormatter.formatPhoneNumberText(newPhoneNumber)
            delegate?.didInputPartialPhoneNumber(number)
        case .valid(number: let number):
            textField.text = phoneNumberPrefix + phoneNumberFormatter.formatPhoneNumberText(newPhoneNumber)
            delegate?.didInputFullPhoneNumber(number)
        }
        return false
    }
}
