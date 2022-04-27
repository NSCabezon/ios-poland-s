//
//  AddTaxPayerInfoView.swift
//  TaxTransfer
//
//  Created by 187831 on 03/02/2022.
//

import UI
import PLUI
import CoreFoundationLib

protocol AddTaxPayerInfoViewDelegate: AnyObject {
    func didUpdateText()
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
    
    func clear() {
        input.textField.setText(nil)
        input.hideError()
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
        input.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .simple,
                    formatter: UIFormattedCustomTextField(),
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
        input.textField.updatableDelegate = self
    }
    
    private func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: containerView,
            sectionTitle: configuration.info
        )
    }
}

extension AddTaxPayerInfoView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        delegate?.didUpdateText()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let limit = configuration.charactersLimit else {
            return true
        }
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= limit
    }
}
