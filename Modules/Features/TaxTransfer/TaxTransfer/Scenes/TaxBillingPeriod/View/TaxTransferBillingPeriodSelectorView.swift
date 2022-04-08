//
//  TaxTransferBillingPeriodSelectorView.swift
//  TaxTransfer
//
//  Created by 187831 on 03/03/2022.
//

import UI
import PLUI

final class TaxTransferBillingPeriodSelectorView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let subviewsContainer = UIView()
    private let selectorView = TaxTransferSelectorView()
    private var currentPeriod: TaxTransferBillingPeriodType?
    private var currentPeriodNumber: Int?
    private var title: String

    init(with title: String) {
        self.title = title
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePeriod(
        with viewModel: Selectable<TaxTransferFormViewModel.TaxBillingPeriodViewModel>,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case let .selected(item):
            showSelected(with: item.periodType, onTap: onTap)
        case .unselected:
            showSelector(onTap: onTap)
        }
    }
    
    func configurePeriodNumber(
        with viewModel: Selectable<Int>,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case let .selected(number):
            showSelected(with: number, onTap: onTap)
        case .unselected:
            showSelector(onTap: onTap)
        }
    }
    
    func getPeriodType() -> TaxTransferBillingPeriodType? {
        return currentPeriod
    }
    
    func getPeriodNumber() -> Int? {
        return currentPeriodNumber
    }
}

private extension TaxTransferBillingPeriodSelectorView {
    func showSelected(
        with periodNumber: Int,
        onTap: @escaping () -> Void
    ) {
        currentPeriodNumber = periodNumber
        selectorView.configure(
            selectionState: .selected("\(periodNumber)"),
            onTap: onTap
        )
    }
    
    func showSelected(
        with period: TaxTransferBillingPeriodType,
        onTap: @escaping () -> Void
    ) {
        currentPeriod = period
        currentPeriodNumber = nil
        selectorView.configure(selectionState: .selected(period.name), onTap: onTap)
    }
    
    func showSelector(onTap: @escaping () -> Void) {
        currentPeriod = nil
        currentPeriodNumber = nil
        selectorView.isHidden = false
        selectorView.configure(selectionState: .unselected, onTap: onTap)
    }
 
    func setUp() {
        configureSubviews()
        showSelector(onTap: {})
    }
    
    func configureSubviews() {
        subviewsContainer.addSubview(selectorView)
        selectorView.translatesAutoresizingMaskIntoConstraints = false
         
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            selectorView.topAnchor.constraint(equalTo: subviewsContainer.topAnchor),
            selectorView.bottomAnchor.constraint(equalTo: subviewsContainer.bottomAnchor),
            selectorView.leadingAnchor.constraint(equalTo: subviewsContainer.leadingAnchor),
            selectorView.trailingAnchor.constraint(equalTo: subviewsContainer.trailingAnchor)
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: subviewsContainer,
            sectionTitle: title
        )
    }
}
