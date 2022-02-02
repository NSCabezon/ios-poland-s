//
//  TaxTransferFormContainerView.swift
//  TaxTransfer
//
//  Created by 185167 on 13/12/2021.
//

import CoreFoundationLib
import UI
import PLUI

protocol TaxTransferFormContainerViewDelegate: AnyObject {
    func scrollToBottom()
    func didUpdateFields(withFields fields: TaxTransferFormFields)
}

final class TaxTransferFormContainerView: UIView {
    private let stackView = UIStackView()
    private let accountSelector = TaxTransferAccountSelectorView()
    private let taxPayerSelector = TaxTransferPayerSelectorView()
    private let taxAuthoritySelector = TaxTransferAuthoritySelectorView()
    private let amountField: TaxTransferAmountFieldView
    private let obligationIdentifierField = TaxTransferObligationIdentifierFieldView()
    private let dateSelector: TaxTransferDateSelectorView
    
    private weak var delegate: TaxTransferFormContainerViewDelegate?
    
    init(
        configuration: TaxFormConfiguration,
        delegate: TaxTransferFormContainerViewDelegate
    ) {
        self.amountField = TaxTransferAmountFieldView(
            configuration: configuration.amountField
        )
        self.dateSelector = TaxTransferDateSelectorView(
            configuration: configuration.dateSelector
        )
        self.delegate = delegate
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func getFormFields() -> TaxTransferFormFields {
        return TaxTransferFormFields(
            amount: amountField.getAmount(),
            obligationIdentifier: obligationIdentifierField.getIdentifier(),
            date: dateSelector.getSelectedDate()
        )
    }
    
    func setInvalidFormMessages(_ messages: TaxTransferFormValidity.InvalidFormMessages) {
        amountField.setInvalidFieldMessage(messages.amountMessage)
        obligationIdentifierField.setInvalidFieldMessage(messages.obligationIdentifierMessage)
    }
    
    func clearInvalidFormMessages() {
        amountField.setInvalidFieldMessage(nil)
        obligationIdentifierField.setInvalidFieldMessage(nil)
    }
    
    func configureAccountSelector(
        with viewModel: Selectable<TaxTransferFormViewModel.AccountViewModel>,
        onTap: @escaping () -> Void
    ) {
        accountSelector.configure(with: viewModel, onTap: onTap)
    }
    
    func configureTaxPayerSelector(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxPayerViewModel>,
        onTap: @escaping () -> Void
    ) {
        taxPayerSelector.configure(with: viewModel, onTap: onTap)
    }
    
    func configureTaxAuthoritySelector(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxAuthorityViewModel>,
        onTap: @escaping () -> Void
    ) {
        taxAuthoritySelector.configure(with: viewModel, onTap: onTap)
    }
    
    func configureAmountField(with viewModel: TaxTransferFormViewModel.AmountViewModel) {
        amountField.configure(with: viewModel)
    }
    
    func configureObligationIdentifierField(with viewModel: TaxTransferFormViewModel) {
        obligationIdentifierField.configure(with: viewModel)
    }
}

private extension TaxTransferFormContainerView {
    func setUp() {
        configureStackView()
        configureSubviews()
        configureDelegates()
    }
    
    func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 25
    }
    
    func configureSubviews() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            accountSelector,
            taxPayerSelector,
            taxAuthoritySelector,
            amountField,
            obligationIdentifierField,
            dateSelector
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureDelegates() {
        amountField.textFieldDelegate = self
        obligationIdentifierField.textFieldDelegate = self
        dateSelector.delegate = self
    }
}

extension TaxTransferFormContainerView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        delegate?.didUpdateFields(withFields: getFormFields())
    }
}

extension TaxTransferFormContainerView: TransferDateSelectorDelegate {
    func didSelectDate(date: Date, withOption option: DateTransferOption) {
        delegate?.didUpdateFields(withFields: getFormFields())
        if option == .anotherDay {
            delegate?.scrollToBottom()
        }
    }
}
