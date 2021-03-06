//
//  TaxTransferBillingPeriodInputView.swift
//  TaxTransfer
//
//  Created by 187831 on 03/03/2022.
//

import UI
import PLUI
import CoreFoundationLib

protocol TaxTransferBillingPeriodInputDelegate: AnyObject {
    func didUpdateText()
}

final class TaxTransferBillingPeriodInputView: UIView {
    weak var delegate: TaxTransferBillingPeriodInputDelegate?
    
    private lazy var sectionContainer = getSectionContainer()
    private let input = LisboaTextFieldWithErrorView()
    private let containerView = UIView()
    private let maxLength: Int
    private let title: String
    
    init(with title: String,
         maxLength: Int = 4) {
        self.title = title
        self.maxLength = maxLength
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
        containerView.addSubview(input)
        input.translatesAutoresizingMaskIntoConstraints = false
        
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
            input.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func configureStyling() {
        let customFormatter = UIFormattedCustomTextField()
        customFormatter.setMaxLength(maxLength: maxLength)
        
        let configuration = LisboaTextField.WritableTextField(
            type: .simple,
            formatter: customFormatter,
            disabledActions: [],
            keyboardReturnAction: nil,
            textfieldCustomizationBlock: { components in
                components.textField.keyboardType = .numberPad
            }
        )
        input.textField.setEditingStyle(.writable(configuration: configuration))
    }
    
    private func configureDelegate() {
        input.textField.updatableDelegate = self
    }
    
    private func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: containerView,
            sectionTitle: title
        )
    }
}

extension TaxTransferBillingPeriodInputView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        delegate?.didUpdateText()
    }
}
