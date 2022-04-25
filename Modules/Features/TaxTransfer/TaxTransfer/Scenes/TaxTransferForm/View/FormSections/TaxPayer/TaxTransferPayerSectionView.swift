//
//  TaxTransferPayerSectionView.swift
//  TaxTransfer
//
//  Created by 185167 on 28/12/2021.
//

import PLUI
import CoreFoundationLib

final class TaxTransferPayerSectionView: UIView {
    private let selectorView = TaxTransferSelectorView()
    private let selectedPayerView = TaxTransferSelectedPayerView()
    private lazy var selectorSection = getSectionContainer(for: selectorView)
    private lazy var payerSection = getSectionContainer(for: selectedPayerView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxPayerViewModel>,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case let .selected(taxPayer):
            showSelectedTaxPayer(taxPayer: taxPayer, onTap: onTap)
        case .unselected:
            showSelector(onTap: onTap)
        }
    }
}

private extension TaxTransferPayerSectionView {
    func showSelectedTaxPayer(
        taxPayer: TaxTransferFormViewModel.TaxPayerViewModel,
        onTap: @escaping () -> Void
    ) {
        selectorSection.isHidden = true
        payerSection.isHidden = false
        selectedPayerView.configure(with: taxPayer, onTap: onTap)
    }
    
    func showSelector(onTap: @escaping () -> Void) {
        selectorSection.isHidden = false
        payerSection.isHidden = true
        selectorView.configure(selectionState: .unselected, onTap: onTap)
    }
    
    func setUp() {
        configureSubviews()
        showSelector(onTap: {})
    }
    
    func configureSubviews() {
        [payerSection, selectorSection].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            selectorSection.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            selectorSection.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectorSection.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorSection.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            payerSection.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            payerSection.bottomAnchor.constraint(equalTo: bottomAnchor),
            payerSection.leadingAnchor.constraint(equalTo: leadingAnchor),
            payerSection.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func getSectionContainer(for view: UIView) -> FormSectionContainer {
        return FormSectionContainer(
            containedView: view,
            sectionTitle: localized("pl_toolbar_title_Payee")
        )
    }
}
