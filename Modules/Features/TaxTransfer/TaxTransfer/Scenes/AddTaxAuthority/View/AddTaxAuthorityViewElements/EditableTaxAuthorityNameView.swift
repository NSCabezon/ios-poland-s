//
//  EditableTaxAuthorityNameView.swift
//  TaxTransfer
//
//  Created by 185167 on 03/03/2022.
//

import CoreFoundationLib
import UI
import PLUI
import PLCommons

final class EditableTaxAuthorityNameView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let containerView = UIView()
    private let authorityNameTextField = LisboaTextFieldWithErrorView()
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
    
    func setTaxAuthorityName(_ name: String?) {
        authorityNameTextField.textField.setText(name)
    }
    
    func getTaxAuthorityName() -> String? {
        return authorityNameTextField.textField.text
    }
    
    func setInvalidFieldMessage(_ message: String?) {
        if let message = message {
            authorityNameTextField.showError(message)
        } else {
            authorityNameTextField.hideError()
        }
    }
}

private extension EditableTaxAuthorityNameView {
    func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    func configureSubviews() {
        containerView.addSubview(authorityNameTextField)
        authorityNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            authorityNameTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            authorityNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            authorityNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            authorityNameTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: containerView,
            sectionTitle: localized("pl_taxTransfer_label_TaxAuthorityName")
        )
    }
    
    func configureStyling() {
        let nameFormatter = UIFormattedCustomTextField()
        nameFormatter.setMaxLength(maxLength: 80)
        nameFormatter.setAllowOnlyCharacters(.ascii)
        authorityNameTextField.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .simple,
                    formatter: nameFormatter,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .asciiCapable
                    }
                )
            )
        )
        authorityNameTextField.textField.placeholder = localized("pl_taxTransfer_label_TaxAuthorityName")
        nameFormatter.delegate = textFieldDelegate
    }
}
