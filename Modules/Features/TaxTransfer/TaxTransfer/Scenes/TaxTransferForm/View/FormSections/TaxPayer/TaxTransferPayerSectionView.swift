//
//  TaxTransferPayerSectionView.swift
//  TaxTransfer
//
//  Created by 185167 on 28/12/2021.
//

import PLUI

final class TaxTransferPayerSectionView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let subviewsContainer = UIView()
    private let selectorView = TaxTransferSelectorView()
    private let selectedPayerView = TaxTransferSelectedPayerView()
    
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
            selectorView.isHidden = true
            selectedPayerView.isHidden = false
            selectedPayerView.configure(with: taxPayer, onTap: onTap)
        case .unselected:
            showSelector(onTap: onTap)
        }
    }
}

private extension TaxTransferPayerSectionView {
    func showSelector(onTap: @escaping () -> Void) {
        selectorView.isHidden = false
        selectedPayerView.isHidden = true
        selectorView.configure(selectionState: .unselected, onTap: onTap)
    }
    
    func setUp() {
        configureSubviews()
        hideSelectedPayerView()
    }
    
    func configureSubviews() {
        [selectorView, selectedPayerView].forEach {
            subviewsContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
         
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
            selectorView.trailingAnchor.constraint(equalTo: subviewsContainer.trailingAnchor),
            
            selectedPayerView.topAnchor.constraint(equalTo: subviewsContainer.topAnchor),
            selectedPayerView.bottomAnchor.constraint(equalTo: subviewsContainer.bottomAnchor),
            selectedPayerView.leadingAnchor.constraint(equalTo: subviewsContainer.leadingAnchor),
            selectedPayerView.trailingAnchor.constraint(equalTo: subviewsContainer.trailingAnchor),
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: subviewsContainer,
            sectionTitle: "#Płatnik"
        )
    }
    
    private func hideSelectedPayerView() {
        selectedPayerView.isHidden = true
    }
}
