//
//  ChequeFormView.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/07/2021.
//

import UI
import PLUI
import Commons
import PLCommons

protocol ChequeFormViewDelegate: AnyObject {
    func didUpdateText()
}

final class ChequeFormView: UIView {
    private let amount = LisboaTextFieldWithErrorView()
    private let amountLimit = UILabel()
    private let validityPeriodSelector = ChequeValidityPeriodSelectorView()
    private let name = LisboaTextFieldWithErrorView()
    private let currency = CurrencyLabel()
    private var selectedPeriod: ChequeValidityPeriod = .hours24
    private weak var delegate: ChequeFormViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setViewModel(viewModel: ChequeFormViewModel, withDelegate delegate: ChequeFormViewDelegate) {
        self.delegate = delegate

        name.textField.placeholder = viewModel.namePlaceholder
        
        amount.textField.placeholder = viewModel.amountPlaceholder
        amount.textField.setRightAccessory(.view(currency))
        currency.setText(viewModel.amountCurrency)
        
        amountLimit.set(localizedStylableText: localized("pl_blik_text_cheque_maxvalue", [StringPlaceholder(.value, viewModel.amountLimit)]))
        selectedPeriod = viewModel.selectedValidityPeriod
        validityPeriodSelector.configureWithPeriods(ChequeValidityPeriod.allCases) { [weak self] period in
            self?.selectedPeriod = period
        }
        validityPeriodSelector.selectElement(viewModel.selectedValidityPeriod)
    }
    
    func getCurrentForm() -> ChequeForm {
        return ChequeForm(
            name: name.textField.text ?? "",
            expirationPeriod: selectedPeriod,
            amount: amount.textField.text ?? "",
            currency: currency.getText()
        )
    }
    
    func showInvalidFormMessages(_ messages: InvalidChequeFormMessages) {
        if messages.invalidAmountMessage == nil {
            amount.hideError()
        } else {
            amount.showError(messages.invalidAmountMessage)
        }
        
        if messages.invalidNameMessage == nil {
            name.hideError()
        } else {
            name.showError(messages.invalidNameMessage)
        }
    }
    
    func clearValidationMessages() {
        name.hideError()
        amount.hideError()
    }
    
    private func setUp() {
        configureSubviews()
        applyStyling()
        configureDelegates()
        setIdentifiers()
    }
    
    private func configureSubviews() {
        [amount, amountLimit, validityPeriodSelector, name].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            amount.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            amount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            amount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            amountLimit.topAnchor.constraint(equalTo: amount.bottomAnchor, constant: 8),
            amountLimit.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            amountLimit.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            validityPeriodSelector.topAnchor.constraint(equalTo: amountLimit.bottomAnchor, constant: 20),
            validityPeriodSelector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            validityPeriodSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            validityPeriodSelector.heightAnchor.constraint(equalToConstant: 48),
            
            name.topAnchor.constraint(equalTo: validityPeriodSelector.bottomAnchor, constant: 16),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    func applyStyling() {
        amount.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .floatingTitle,
                    formatter: PLAmountTextFieldFormatter(),
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .decimalPad
                    }
                )
            )
        )
        name.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .floatingTitle,
                    formatter: nil,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { _ in }
                )
            )
        )
        amountLimit.textColor = .brownishGray
        amountLimit.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        amountLimit.numberOfLines = 1
    }
    
    private func configureDelegates() {
        amount.textField.updatableDelegate = self
        name.textField.updatableDelegate = self
    }
    
    private func setIdentifiers() {
        amount.accessibilityIdentifier = AccessibilityCheques.ChequeFormView.amount.id
        amountLimit.accessibilityIdentifier = AccessibilityCheques.ChequeFormView.amountLimit.id
        name.accessibilityIdentifier = AccessibilityCheques.ChequeFormView.name.id
    }
}

extension ChequeFormView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        delegate?.didUpdateText()
    }
}
