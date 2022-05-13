//
//  PhoneNumberInputView.swift
//  PhoneTopUp
//
//  Created by 188216 on 29/11/2021.
//

import UI
import UIKit
import PLUI
import CoreFoundationLib
import PLCommons

protocol PhoneNumberInputViewDelegate: AnyObject {
    func didTouchContactsButton()
    func didInputPartialPhoneNumber(_ number: String)
    func didInputFullPhoneNumber(_ number: String)
}

final class PhoneNumberInputView: UIView {
    // MARK: Views
    
    private let textInputView = FormTextInputView()
    
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
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(textInputView)
    }
    
    private func prepareStyles() {
        textInputView.setHeaderTitle(localized("pl_topup_text_recipPhoneNumb"))
        
        textInputView.textField.setRightAccessory(.uiImage(Images.Form.contactIcon, action: { [weak self] in
            self?.delegate?.didTouchContactsButton()
        }))
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: nil,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textFieldDelegate: nil) { component in
            component.textField.keyboardType = .phonePad
        }
        textInputView.textField.setEditingStyle(.writable(configuration: configuration))
        textInputView.textField.fieldDelegate = self
        textInputView.textField.setText(phoneNumberPrefix)
    }
    
    // MARK: Methods
    
    func showInvalidPhoneNumberError(_ showError: Bool) {
        if showError {
            textInputView.setErrorAppearance(message: localized("pl_topup_text_valid_wrongNumb"))
        } else {
            textInputView.clearErrorAppearance()
        }
    }
    
    func updatePhoneInput(with phoneNumber: String) {
        let formattedPhoneNumber = phoneNumberPrefix + phoneNumberFormatter.formatPhoneNumberText(phoneNumber)
        textInputView.textField.setText(formattedPhoneNumber)
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
