//
//  AddTaxAuthorityContainerView.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import CoreFoundationLib
import UI
import PLUI

protocol AddTaxAuthorityContainerViewDelegate: AnyObject {
    func didUpdateFields(
        taxAuthorityName: String?,
        accountNumber: String?
    )
}

final class AddTaxAuthorityContainerView: UIView {
    private let stackView = UIStackView()
    private lazy var editableTaxAuthorityNameView = EditableTaxAuthorityNameView(delegate: self)
    private lazy var editableTaxAccountView = EditableTaxAccountView(delegate: self)
    private let nonEditableTaxAccountView = NonEditableTaxAccountView()
    private let irpWarningView = IrpWarningSectionView()
    private let taxFormSymbolSelectorView = TaxFormSelectorSectionView(
        sectionTitle: localized("pl_toolbar_formSymbol")
    )
    private let citySelectorView = TaxFormSelectorSectionView(
        sectionTitle: "#Miasto:"
    )
    private let taxAuthorityNameSelectorView = TaxFormSelectorSectionView(
        sectionTitle: "#Nazwa organu:"
    )
    
    private weak var delegate: AddTaxAuthorityContainerViewDelegate?
    
    init(delegate: AddTaxAuthorityContainerViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func showTaxSymbolSelector(onTaxSymbolTap: @escaping () -> Void) {
        hideAllFormElements()
        taxFormSymbolSelectorView.configure(with: .unselected, onTap: onTaxSymbolTap)
        stackView.addArrangedSubview(taxFormSymbolSelectorView)
        layoutIfNeeded()
    }
    
    func showUsForm(
        viewModel: AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel,
        onTaxSymbolTap: @escaping () -> Void,
        onCityTap: @escaping () -> Void,
        onTaxAuthorityTap: @escaping () -> Void
    ) {
        defer { layoutIfNeeded() }
        hideAllFormElements()
        addTaxSymbolSelectorElement(with: viewModel.taxSymbol, onTap: onTaxSymbolTap)
        addCitySelectorElement(with: viewModel.city, onTap: onCityTap)
        
        guard shouldShowFurtherElements(after: viewModel.city) else {
            return
        }
        
        addTaxAuthoritySelectorAndAccountNumberElements(
            with: viewModel.taxAuthority,
            onTaxAuthorityTap: onTaxAuthorityTap
        )
    }
    
    func showIrpForm(
        viewModel: AddTaxAuthorityViewModel.IrpTaxAuthorityFormViewModel,
        onTaxSymbolTap: @escaping () -> Void
    ) {
        hideAllFormElements()
        addTaxSymbolSelectorElement(with: viewModel.taxSymbol, onTap: onTaxSymbolTap)
        addEditableTaxAuthorityNameElement(with: viewModel.taxAuthorityName)
        addEditableAccountNumberElement(with: viewModel.accountNumber)
        addIrpWarningView()
        layoutIfNeeded()
    }
    
    func showInvalidFormMessages(_ messages: InvalidTaxAuthorityFormFormMessages) {
        editableTaxAuthorityNameView.setInvalidFieldMessage(messages.invalidTaxAuthorityNameMessage)
        editableTaxAccountView.setInvalidFieldMessage(messages.invalidAccountNumberMessage)
    }
    
    func clearInvalidFormMessages() {
        editableTaxAuthorityNameView.setInvalidFieldMessage(nil)
        editableTaxAccountView.setInvalidFieldMessage(nil)
    }
}

private extension AddTaxAuthorityContainerView {
    func setUp() {
        configureStackView()
        configureSubviews()
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
            taxFormSymbolSelectorView,
            citySelectorView,
            taxAuthorityNameSelectorView,
            editableTaxAuthorityNameView,
            editableTaxAccountView,
            nonEditableTaxAccountView,
            irpWarningView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func hideAllFormElements() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.isHidden = true
        }
    }
    
    func shouldShowFurtherElements<T>(after viewModel: Selectable<T>) -> Bool {
        switch viewModel {
        case .selected:
            return true
        case .unselected:
            return false
        }
    }
    
    func addTaxSymbolSelectorElement(with symbolName: String, onTap: @escaping () -> Void) {
        taxFormSymbolSelectorView.configure(with: .selected(symbolName), onTap: onTap)
        stackView.addArrangedSubview(taxFormSymbolSelectorView)
        taxFormSymbolSelectorView.isHidden = false
    }
    
    func addCitySelectorElement(
        with viewModel: Selectable<AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel.CityName>,
        onTap: @escaping () -> Void
    ) {
        citySelectorView.configure(with: viewModel, onTap: onTap)
        stackView.addArrangedSubview(citySelectorView)
        citySelectorView.isHidden = false
    }
    
    func addTaxAuthoritySelectorAndAccountNumberElements(
        with viewModel: Selectable<AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel.TaxAuthorityViewModel>,
        onTaxAuthorityTap: @escaping () -> Void
    ) {
        switch viewModel {
        case .unselected:
            taxAuthorityNameSelectorView.configure(with: .unselected, onTap: onTaxAuthorityTap)
            stackView.addArrangedSubview(taxAuthorityNameSelectorView)
            taxAuthorityNameSelectorView.isHidden = false
        case let .selected(viewModel):
            taxAuthorityNameSelectorView.configure(with: .selected(viewModel.taxAuthorityName), onTap: onTaxAuthorityTap)
            nonEditableTaxAccountView.configure(with: viewModel.accountNumber)
            stackView.addArrangedSubview(taxAuthorityNameSelectorView)
            stackView.addArrangedSubview(nonEditableTaxAccountView)
            taxAuthorityNameSelectorView.isHidden = false
            nonEditableTaxAccountView.isHidden = false
        }
    }
    
    func addEditableTaxAuthorityNameElement(with taxAuthorityName: String?) {
        editableTaxAuthorityNameView.setTaxAuthorityName(taxAuthorityName)
        stackView.addArrangedSubview(editableTaxAuthorityNameView)
        editableTaxAuthorityNameView.isHidden = false
    }
    
    func addEditableAccountNumberElement(with accountNumber: String?) {
        editableTaxAccountView.setAccountNumber(accountNumber)
        stackView.addArrangedSubview(editableTaxAccountView)
        editableTaxAccountView.isHidden = false
    }
    
    func addIrpWarningView() {
        stackView.addArrangedSubview(irpWarningView)
        irpWarningView.isHidden = false
    }
}

extension AddTaxAuthorityContainerView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.didUpdateFields(
            taxAuthorityName: editableTaxAuthorityNameView.getTaxAuthorityName(),
            accountNumber: editableTaxAccountView.getAccountNumber()
        )
    }
}
