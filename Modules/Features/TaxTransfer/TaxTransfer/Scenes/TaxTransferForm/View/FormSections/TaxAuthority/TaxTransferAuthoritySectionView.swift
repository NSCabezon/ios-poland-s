//
//  TaxTransferAuthoritySectionView.swift
//  TaxTransfer
//
//  Created by 185167 on 28/12/2021.
//

import PLUI
import CoreFoundationLib

final class TaxTransferAuthoritySectionView: UIView {
    private lazy var taxAuthoritySection = getSectionContainer(with: taxAuthorityView)
    private lazy var selectorSection = getSectionContainer(with: selectorView)
    private let taxAuthorityView = TaxTransferSelectedTaxAuthorityView()
    private let selectorView = TaxTransferSelectorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxAuthorityViewModel>,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case let .selected(viewModel):
            showSelectedTaxAuthority(
                viewModel: viewModel,
                onTap: onTap
            )
        case .unselected:
            showSelector(onTap: onTap)
        }
    }
}

private extension TaxTransferAuthoritySectionView {
    func showSelectedTaxAuthority(
        viewModel: TaxTransferFormViewModel.TaxAuthorityViewModel,
        onTap: @escaping () -> Void
    ) {
        selectorSection.isHidden = true
        taxAuthoritySection.isHidden = false
        taxAuthorityView.configure(with: viewModel, onTap: onTap)
    }
    
    func showSelector(onTap: @escaping () -> Void) {
        taxAuthoritySection.isHidden = true
        selectorSection.isHidden = false
        selectorView.configure(selectionState: .unselected, onTap: onTap)
    }
    
    func setUp() {
        configureSubviews()
        showSelector(onTap: {})
    }
    
    func configureSubviews() {
        [taxAuthoritySection, selectorSection].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            taxAuthoritySection.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            taxAuthoritySection.bottomAnchor.constraint(equalTo: bottomAnchor),
            taxAuthoritySection.leadingAnchor.constraint(equalTo: leadingAnchor),
            taxAuthoritySection.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            selectorSection.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            selectorSection.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectorSection.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorSection.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func getSectionContainer(with view: UIView) -> FormSectionContainer {
        return FormSectionContainer(
            containedView: view,
            sectionTitle: localized("pl_toolbar_taxAuthority")
        )
    }
}
