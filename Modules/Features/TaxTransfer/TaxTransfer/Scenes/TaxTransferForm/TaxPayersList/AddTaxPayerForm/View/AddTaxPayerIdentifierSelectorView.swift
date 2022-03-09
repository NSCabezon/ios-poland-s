//
//  AddTaxPayerIdentifierSelectorView.swift
//  TaxTransfer
//
//  Created by 187831 on 03/02/2022.
//

import UI
import PLUI

final class AddTaxPayerIdentifierSelectorView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let subviewsContainer = UIView()
    private let selectorView = TaxTransferSelectorView()
    
    private var currentIdentifier: TaxIdentifierType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        with identifier: Selectable<TaxIdentifierType>,
        onTap: @escaping () -> Void
    ) {
        switch identifier {
        case let .selected(type):
            currentIdentifier = type
            selectorView.configure(selectionState: .selected(type.name), onTap: onTap)
        case .unselected:
            currentIdentifier = nil
            selectorView.configure(selectionState: .unselected, onTap: onTap)
        }
    }
    
    func getIdentifierType() -> TaxIdentifierType? {
        return currentIdentifier
    }
    
    private func setUp() {
        configureSubviews()
    }
    
    private func configureSubviews() {
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
    
    private func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: subviewsContainer,
            sectionTitle: "#Typ identyfikatora:"
        )
    }
}
