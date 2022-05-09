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
    func clearForm()
}

final class TaxTransferFormContainerView: UIView {
    private let stackView = UIStackView()
    private let accountSection = TaxTransferAccountSectionView()
    private let taxPayerSection = TaxTransferPayerSectionView()
    private let taxAuthoritySection = TaxTransferAuthoritySectionView()
    private let taxBillingPeriodSection = TaxTransferBillingPeriodView()
    private let amountSection: TaxTransferAmountSectionView
    private let obligationIdentifierSection = TaxTransferObligationIdentifierSectionView()
    private let dateSection: TaxTransferDateSectionView
    
    private weak var delegate: TaxTransferFormContainerViewDelegate?
    
    init(
        configuration: TaxFormConfiguration,
        delegate: TaxTransferFormContainerViewDelegate
    ) {
        self.amountSection = TaxTransferAmountSectionView(
            configuration: configuration.amountField
        )
        self.dateSection = TaxTransferDateSectionView(
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
            amount: amountSection.getAmount(),
            obligationIdentifier: obligationIdentifierSection.getIdentifier(),
            date: dateSection.getSelectedDate()
        )
    }
    
    func setInvalidFormMessages(_ messages: TaxTransferFormValidity.InvalidFormMessages) {
        amountSection.setInvalidFieldMessage(messages.amountMessage)
        obligationIdentifierSection.setInvalidFieldMessage(messages.obligationIdentifierMessage)
    }
    
    func clearInvalidFormMessages() {
        amountSection.setInvalidFieldMessage(nil)
        obligationIdentifierSection.setInvalidFieldMessage(nil)
    }
    
    func configureAccountSelector(
        with viewModel: Selectable<TaxTransferFormViewModel.AccountViewModel>,
        onTap: @escaping () -> Void
    ) {
        accountSection.configure(with: viewModel, onTap: onTap)
    }
    
    func configureTaxPayerSelector(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxPayerViewModel>,
        onTap: @escaping () -> Void
    ) {
        taxPayerSection.configure(with: viewModel, onTap: onTap)
    }
    
    func configureTaxAuthoritySelector(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxAuthorityViewModel>,
        onTap: @escaping () -> Void
    ) {
        taxAuthoritySection.configure(with: viewModel, onTap: onTap)
    }
    
    func configureTaxBillingPeriodSelector(
        with viewModel: TaxTransferFormViewModel.BillingPeriodVisibility,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case let .visible(selectableViewModel):
            taxBillingPeriodSection.configure(with: selectableViewModel, onTap: onTap)
            taxBillingPeriodSection.isHidden = false
        case .hidden:
            taxBillingPeriodSection.isHidden = true
        }
    }
    
    func configureAmountField(with viewModel: TaxTransferFormViewModel.AmountViewModel) {
        amountSection.configure(with: viewModel)
    }
    
    func configureObligationIdentifierField(with viewModel: TaxTransferFormViewModel) {
        obligationIdentifierSection.configure(with: viewModel)
    }
    
    func clearForm() {
        amountSection.clear()
        obligationIdentifierSection.clear()
        dateSection.clear()
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
        stackView.spacing = 0
    }
    
    func configureSubviews() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            accountSection,
            taxPayerSection,
            taxAuthoritySection,
            taxBillingPeriodSection,
            amountSection,
            obligationIdentifierSection,
            dateSection
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
        taxBillingPeriodSection.isHidden = true
    }
    
    func configureDelegates() {
        amountSection.textFieldDelegate = self
        obligationIdentifierSection.textFieldDelegate = self
        dateSection.delegate = self
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
