//
//  TaxTransferBillingPeriodView.swift
//  Transfer
//
//  Created by 187831 on 03/03/2022.
//

import PLUI
import CoreFoundationLib

final class TaxTransferBillingPeriodView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let subviewsContainer = UIView()
    private let selectorView = TaxTransferSelectorView()
    private let selectedPeriodView = TaxTransferSelectedBillingPeriodView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxBillingPeriodViewModel>,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case let .selected(billingPeriod):
            showSelectedBillingPeriod(viewModel: billingPeriod, onTap: onTap)
        case .unselected:
            showSelector(onTap: onTap)
        }
    }
}

private extension TaxTransferBillingPeriodView {
    func showSelectedBillingPeriod(
        viewModel: TaxTransferFormViewModel.TaxBillingPeriodViewModel,
        onTap: @escaping () -> Void
    ) {
        selectorView.isHidden = true
        selectedPeriodView.isHidden = false
        selectedPeriodView.setUp(viewModel: viewModel, onTap: onTap)
    }
    
    func showSelector(onTap: @escaping () -> Void) {
        selectorView.isHidden = false
        selectedPeriodView.isHidden = true
        selectorView.configure(selectionState: .unselected, onTap: onTap)
    }
    
    func setUp() {
        configureSubviews()
        showSelector(onTap: {})
    }
    
    func configureSubviews() {
        [selectorView, selectedPeriodView].forEach {
            subviewsContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
         
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            selectorView.topAnchor.constraint(equalTo: subviewsContainer.topAnchor),
            selectorView.bottomAnchor.constraint(equalTo: subviewsContainer.bottomAnchor),
            selectorView.leadingAnchor.constraint(equalTo: subviewsContainer.leadingAnchor),
            selectorView.trailingAnchor.constraint(equalTo: subviewsContainer.trailingAnchor),
            
            selectedPeriodView.topAnchor.constraint(equalTo: subviewsContainer.topAnchor),
            selectedPeriodView.bottomAnchor.constraint(equalTo: subviewsContainer.bottomAnchor),
            selectedPeriodView.leadingAnchor.constraint(equalTo: subviewsContainer.leadingAnchor),
            selectedPeriodView.trailingAnchor.constraint(equalTo: subviewsContainer.trailingAnchor),
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: subviewsContainer,
            sectionTitle: localized("pl_taxTransfer_label_settlementPeriod")
        )
    }
}
