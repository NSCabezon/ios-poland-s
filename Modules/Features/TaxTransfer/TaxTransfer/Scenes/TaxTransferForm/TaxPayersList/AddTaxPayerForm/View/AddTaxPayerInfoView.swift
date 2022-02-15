//
//  AddTaxPayerInfoView.swift
//  TaxTransfer
//
//  Created by 187831 on 03/02/2022.
//

import UI
import PLUI
import Commons

protocol AddTaxPayerInfoViewDelegate: AnyObject {
    func didEndEditing()
}

final class AddTaxPayerInfoView: UIView {
    weak var delegate: AddTaxPayerInfoViewDelegate?
    
    private lazy var sectionContainer = getSectionContainer()
    private let containerView = UIView()
    private let input = LisboaTextFieldWithErrorView()
    private let charactersLimit = UILabel()
    private let configuration: AddTaxPayerFormConfiguration
    
    init(with configuration: AddTaxPayerFormConfiguration) {
        self.configuration = configuration

        super.init(frame: .zero)

        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getInputText() -> String {
        return input.textField.fieldValue ?? ""
    }
    
    func hideError() {
        input.hideError()
    }
    
    func showError(_ message: String?) {
        input.showError(message)
    }
    
    private func setUp() {
        configureSubviews()
        configureStyling()
        configureDelegate()
    }
    
    private func configureSubviews() {
        [input, charactersLimit].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            input.topAnchor.constraint(equalTo: containerView.topAnchor),
            input.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            input.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            charactersLimit.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 8),
            charactersLimit.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            charactersLimit.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            charactersLimit.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configureStyling() {
        let formatter = UIFormattedCustomTextField()
        
        if let limit = configuration.charactersLimit {
            formatter.setMaxLength(maxLength: limit)
        }
        
        input.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .simple,
                    formatter: formatter,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .asciiCapable
                    }
                )
            )
        )
        
        charactersLimit.text = configuration.charactersLimitInfo
        charactersLimit.textColor = .brownishGray
        charactersLimit.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
    }
    
    private func configureDelegate() {
        input.textField.fieldDelegate = self
    }
    
    private func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: containerView,
            sectionTitle: configuration.info
        )
    }
}

extension AddTaxPayerInfoView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditing()
    }
}
