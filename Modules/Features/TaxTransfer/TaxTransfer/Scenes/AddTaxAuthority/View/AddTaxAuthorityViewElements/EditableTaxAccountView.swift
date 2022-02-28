//
//  EditableTaxAccountView.swift
//  TaxTransfer
//
//  Created by 185167 on 16/02/2022.
//

import CoreFoundationLib
import UI
import PLUI

final class EditableTaxAccountView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let containerView = UIView()
    private let accountTextField = LisboaTextFieldWithErrorView()
    weak var textFieldDelegate: UpdatableTextFieldDelegate? {
        didSet {
            accountTextField.textField.updatableDelegate = textFieldDelegate
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
            sectionTitle: "#Numer rachunku/ aka Konto"
        )
    }
    
    func configureStyling() {
        accountTextField.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .simple,
                    formatter: nil,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .numberPad
                    }
                )
            )
        )
    }
}
