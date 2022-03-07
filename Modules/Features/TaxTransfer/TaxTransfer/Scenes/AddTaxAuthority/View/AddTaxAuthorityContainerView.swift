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
    func didUpdateFields()
}

final class AddTaxAuthorityContainerView: UIView {
    private let stackView = UIStackView()
    private let editableTaxAuthorityNameView = EditableTaxAuthorityNameView()
    private let editableTaxAccountView = EditableTaxAccountView()
    private let nonEditableTaxAccountView = NonEditableTaxAccountView()
    private let irpWarningView = IrpWarningSectionView()
    private let taxFormSymbolSelectorView = TaxFormSelectorSectionView(
        sectionTitle: "#Symbol formularza:"
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
        
        layoutIfNeeded()
    }
    
    func showIrpForm(
        viewModel: AddTaxAuthorityViewModel.IrpTaxAuthorityFormViewModel,
        onTaxSymbolTap: @escaping () -> Void
    ) {
        hideAllFormElements()
        addTaxSymbolSelectorElement(with: viewModel.taxSymbol, onTap: onTaxSymbolTap)
        addEditableTaxAuthorityNameElement(with: viewModel.taxAuthorityName)
        addEditableAccountNumberElement(with: viewModel.accountNumber)
        stackView.addArrangedSubview(irpWarningView)
        layoutIfNeeded()
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
    }
    
    func addCitySelectorElement(
        with viewModel: Selectable<AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel.CityName>,
        onTap: @escaping () -> Void
    ) {
        citySelectorView.configure(with: viewModel, onTap: onTap)
        stackView.addArrangedSubview(citySelectorView)
    }
    
    func addTaxAuthoritySelectorAndAccountNumberElements(
        with viewModel: Selectable<AddTaxAuthorityViewModel.UsTaxAuthorityFormViewModel.TaxAuthorityViewModel>,
        onTaxAuthorityTap: @escaping () -> Void
    ) {
        switch viewModel {
        case .unselected:
            taxAuthorityNameSelectorView.configure(with: .unselected, onTap: onTaxAuthorityTap)
            stackView.addArrangedSubview(taxAuthorityNameSelectorView)
        case let .selected(viewModel):
            taxAuthorityNameSelectorView.configure(with: .selected(viewModel.taxAuthorityName), onTap: onTaxAuthorityTap)
            nonEditableTaxAccountView.configure(with: viewModel.accountNumber)
            stackView.addArrangedSubview(taxAuthorityNameSelectorView)
            stackView.addArrangedSubview(nonEditableTaxAccountView)
        }
    }
    
    func addEditableTaxAuthorityNameElement(with taxAuthorityName: String?) {
        editableTaxAuthorityNameView.setTaxAuthorityName(taxAuthorityName)
        stackView.addArrangedSubview(editableTaxAuthorityNameView)
    }
    
    func addEditableAccountNumberElement(with accountNumber: String?) {
        editableTaxAccountView.setAccountNumber(accountNumber)
        stackView.addArrangedSubview(editableTaxAccountView)
    }
}
