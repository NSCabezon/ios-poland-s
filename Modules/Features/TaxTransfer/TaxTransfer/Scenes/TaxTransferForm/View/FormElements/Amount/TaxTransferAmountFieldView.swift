//
//  TaxTransferAmountFieldView.swift
//  TaxTransfer
//
//  Created by 185167 on 29/12/2021.
//

import UI
import PLUI

final class TaxTransferAmountFieldView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let amount = LisboaTextFieldWithErrorView()
    private let currency = CurrencyLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        configure(with: .init(amount: "", currency: "PLN")) // TODO:- Remove after hooking up data with presenter
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(with viewModel: TaxTransferFormViewModel.Amount) {
        amount.textField.setText(viewModel.amount)
        currency.setText(viewModel.currency)
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
    }
}


