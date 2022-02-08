//
//  TaxTransferAmountFieldView.swift
//  TaxTransfer
//
//  Created by 185167 on 29/12/2021.
//

import CoreFoundationLib
import UI
import PLUI

final class TaxTransferAmountFieldView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let amount = LisboaTextFieldWithErrorView()
    private let currency = CurrencyLabel()
    private let amountFormatter: NumberFormatter
    weak var textFieldDelegate: UpdatableTextFieldDelegate? {
        didSet {
            amount.textField.updatableDelegate = textFieldDelegate
        }
    }
    
    init(configuration: TaxFormConfiguration.AmountFieldConfiguration) {
        self.amountFormatter = configuration.amountFormatter
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(with viewModel: TaxTransferFormViewModel.AmountViewModel) {
        amount.textField.setText(viewModel.amount)
        currency.setText(viewModel.currency)
    }
    
    func getAmount() -> String {
        return amount.textField.text ?? ""
    }
    
    func setInvalidFieldMessage(_ message: String?) {
        if let message = message {
            amount.showError(message)
        } else {
            amount.hideError()
        }
    }
}

private extension TaxTransferAmountFieldView {
    func setUp() {
        configureSubviews()
        configureAmountField()
    }
    
    func configureSubviews() {
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: amount,
            sectionTitle: "#Kwota"
        )
    }
    
    func configureAmountField() {
        amount.textField.placeholder = "#Kwota"
        amount.textField.setRightAccessory(.view(currency))
        amount.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .simple,
                    formatter: PLAmountTextFieldFormatter(),
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: self,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .decimalPad
                    }
                )
            )
        )
    }
}

extension TaxTransferAmountFieldView: FloatingTitleLisboaTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // empty implementation, required by protocol
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let amountAsNumber = amountFormatter.number(from: textField.text ?? "0,00") ?? NSNumber(value: 0)
        let formattedAmount = amountFormatter.string(from: amountAsNumber)
        amount.textField.setText(formattedAmount)
    }
}
