//
//  TaxTransferAuthoritySelectorView.swift
//  TaxTransfer
//
//  Created by 185167 on 28/12/2021.
//

import PLUI

final class TaxTransferAuthoritySelectorView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let subviewsContainer = UIView()
    private let selectorView = TaxTransferElementSelectorView()
    private let selectedAuthorityView = UIView() // TODO:- Implementation in other TAP story
    
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
        with viewModel: TaxTransferFormViewModel.TaxAuthority,
        onTap: @escaping () -> Void
    ) {
        switch viewModel {
        case .selected:
            selectorView.isHidden = true
            selectedAuthorityView.isHidden = false
            // TODO:- Further view implementation in another TAP story
        case .unselected:
            selectorView.isHidden = false
            selectedAuthorityView.isHidden = true
            selectorView.configure(onTap: onTap)
        }
    }
}

private extension TaxTransferAuthoritySelectorView {
    func setUp() {
        configureSubviews()
    }
    
    func configureSubviews() {
        [selectorView, selectedAuthorityView].forEach {
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
            
            selectedAuthorityView.topAnchor.constraint(equalTo: subviewsContainer.topAnchor),
            selectedAuthorityView.bottomAnchor.constraint(equalTo: subviewsContainer.bottomAnchor),
            selectedAuthorityView.leadingAnchor.constraint(equalTo: subviewsContainer.leadingAnchor),
            selectedAuthorityView.trailingAnchor.constraint(equalTo: subviewsContainer.trailingAnchor),
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: subviewsContainer,
            sectionTitle: "#Organ podatkowy"
        )
    }
}

