//
//  EditableTaxAccountView.swift
//  TaxTransfer
//
//  Created by 185167 on 16/02/2022.
//

import CoreFoundationLib
import UI
import PLUI
import UIKit

final class EditableTaxAccountView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let containerView = UIView()
    private let accountTextField = LisboaTextFieldWithErrorView()
    private weak var textFieldDelegate: UITextFieldDelegate?
    
    init(delegate: UITextFieldDelegate) {
        self.textFieldDelegate = delegate
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setAccountNumber(_ number: String?) {
        accountTextField.textField.setText(number)
    }
    
    func getAccountNumber() -> String? {
        return accountTextField.textField.text
    }
    
    func setInvalidFieldMessage(_ message: String?) {
        if let message = message {
            accountTextField.showError(message)
        } else {
            accountTextField.hideError()
        }
    }
}

private extension EditableTaxAccountView {
    func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    func configureSubviews() {
        containerView.addSubview(accountTextField)
        accountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            accountTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            accountTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            accountTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            accountTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: containerView,
            sectionTitle: localized("generic_label_taxAuthorityAcc")
        )
    }
    
    func configureStyling() {
        let accountFormatter = PLAccountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(
            type: .simple,
            formatter: accountFormatter,
            disabledActions: [],
            keyboardReturnAction: nil,
            textFieldDelegate: nil) { component in
            component.textField.keyboardType = .numberPad
        }
        accountTextField.textField.placeholder = localized("generic_label_taxAuthorityAcc")
        accountTextField.textField.setEditingStyle(.writable(configuration: configuration))
        accountFormatter.delegate = textFieldDelegate
    }
}
