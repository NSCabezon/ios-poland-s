//
//  PhoneNumberInputView.swift
//  PhoneTopUp
//
//  Created by 188216 on 29/11/2021.
//

import UIKit
import PLUI
import Commons
import PLCommons

final class PhoneNumberInputView: UIView {
    // MARK: Views
    
    private let mainContainer = UIStackView()
    private let headerLabel = UILabel()
    private let errorLabel = UILabel()
    private let phoneSectionContainer = UIStackView()
    private let phoneInputBackground = UIView()
    private let phoneInputContainer = UIStackView()
    private let phoneNumberPrefixLabel = UILabel()
    private let phoneNumberTextField = UITextField()
    private let phoneInputBottomBorderView = UIView()
    private let phoneInputVerticalSeparator = UIView()
    private let contactsButton = UIButton()
    
    // MARK: Properties
    
    private let phoneNumberValidator = PartialPhoneNumberValidator()
    private let phoneNumberFormatter = PartialPhoneNumberFormatter()
    private let phoneNumberPrefix = "+48"

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
        mainContainer.addArrangedSubview(phoneSectionContainer)
        mainContainer.addArrangedSubview(errorLabel)
        phoneSectionContainer.addArrangedSubview(phoneInputBackground)
        phoneSectionContainer.addArrangedSubview(phoneInputBottomBorderView)
        phoneInputBackground.addSubviewConstraintToEdges(phoneInputContainer)
        phoneInputContainer.addArrangedSubview(phoneNumberPrefixLabel)
        phoneInputContainer.addArrangedSubview(phoneNumberTextField)
        phoneInputContainer.addArrangedSubview(phoneInputVerticalSeparator)
        phoneInputContainer.addArrangedSubview(contactsButton)
    }
    
    private func prepareStyles() {
        headerLabel.text = localized("pl_topup_text_recipPhoneNumb")
        headerLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        headerLabel.textColor = .lisboaGray
        
        errorLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        errorLabel.textColor = .santanderRed
        errorLabel.text = localized("pl_topup_text_valid_wrongNumb")
        errorLabel.isHidden = true
        
        phoneNumberPrefixLabel.text = phoneNumberPrefix
        phoneNumberPrefixLabel.font = .santander(family: .micro, type: .regular, size: 16.0)
        phoneNumberPrefixLabel.textColor = .brownishGray
        
        #warning("todo: remove this mock text")
        phoneNumberTextField.text = "506 668 348"
        phoneNumberTextField.font = .santander(family: .micro, type: .regular, size: 16.0)
        phoneNumberTextField.textColor = .brownishGray
        phoneNumberTextField.keyboardType = .numberPad
        
        phoneInputBackground.backgroundColor = .skyGray
        phoneInputBackground.borders(for: [.top, .left, .right], width: 1.0, color: .mediumSkyGray)
        
        phoneInputBottomBorderView.backgroundColor = .darkTurqLight
        
        contactsButton.setImage(Images.Form.contactIcon, for: .normal)
        
        phoneInputVerticalSeparator.backgroundColor = .mediumSkyGray
    }
    
    private func setUpLayout() {
        mainContainer.axis = .vertical
        mainContainer.spacing = 8.0
        
        phoneSectionContainer.axis = .vertical
        
        phoneInputContainer.axis = .horizontal
        phoneInputContainer.isLayoutMarginsRelativeArrangement = true
        phoneInputContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12.0, leading: 16.0, bottom: 12.0, trailing: 16.0)
        phoneInputContainer.spacing = 12.0
        
        phoneNumberPrefixLabel.textAlignment = .right
        phoneNumberPrefixLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        phoneNumberTextField.textAlignment = .left
        phoneNumberTextField.delegate = self
        
        phoneInputBottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            phoneSectionContainer.heightAnchor.constraint(equalToConstant: 48.0),
            phoneInputBottomBorderView.heightAnchor.constraint(equalToConstant: 1.0),
            phoneInputVerticalSeparator.widthAnchor.constraint(equalToConstant: 1.0),
            contactsButton.widthAnchor.constraint(equalTo: contactsButton.heightAnchor),
        ])
    }
}

extension PhoneNumberInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text, let range = Range(range, in: currentText) else {
            return true
        }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        if phoneNumberValidator.validatePhoneNumberText(newText) {
            textField.text = phoneNumberFormatter.formatPhoneNumberText(newText)
        }
        // prevent unchecked and unformatted user input
        return false
    }
}
