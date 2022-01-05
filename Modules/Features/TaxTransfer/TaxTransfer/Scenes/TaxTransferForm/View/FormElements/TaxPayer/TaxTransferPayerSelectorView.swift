//
//  TaxTransferPayerSelectorView.swift
//  TaxTransfer
//
//  Created by 185167 on 28/12/2021.
//

import PLUI

final class TaxTransferPayerSelectorView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let subviewsContainer = UIView()
    private let selectorView = TaxTransferElementSelectorView()
    private let selectedPayerView = UIView() // TODO:- Implementation in other TAP story
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        configure(with: .unselected, onTap: {}) // TODO:- Remove this line. Implementation of config in other TAP story
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(
        with viewModel: TaxTransferFormViewModel.TaxPayer,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case .selected:
            selectorView.isHidden = true
            selectedPayerView.isHidden = false
            // TODO:- Further view implementation in another TAP story
        case .unselected:
            selectorView.isHidden = false
            selectedPayerView.isHidden = true
            selectorView.configure(onTap: onTap)
        }
    }
}

private extension TaxTransferPayerSelectorView {
    func setUp() {
        configureSubviews()
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
}
