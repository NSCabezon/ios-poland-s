//
//  EditableTaxAuthorityNameView.swift
//  TaxTransfer
//
//  Created by 185167 on 03/03/2022.
//

import CoreFoundationLib
import UI
import PLUI

final class EditableTaxAuthorityNameView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let containerView = UIView()
    private let authorityNameTextField = LisboaTextFieldWithErrorView()
    weak var textFieldDelegate: UpdatableTextFieldDelegate? {
        didSet {
            authorityNameTextField.textField.updatableDelegate = textFieldDelegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setTaxAuthorityName(_ name: String?) {
        authorityNameTextField.textField.setText(name)
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
            sectionTitle: "#Nazwa Organu"
        )
    }
    
    func configureStyling() {
        authorityNameTextField.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .simple,
                    formatter: nil,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .asciiCapable
                    }
                )
            )
        )
    }
}
