//
//  TaxFormSymbolSelectorView.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import PLUI

final class TaxFormSelectorSectionView: UIView {
    private lazy var section = getSectionContainer(with: selectorView)
    private let selectorView = TaxTransferSelectorView()
    private let sectionTitle: String
    
    init(sectionTitle: String) {
        self.sectionTitle = sectionTitle
        super.init(frame: .zero)
        configureSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(
        with selectionState: Selectable<TaxTransferSelectorView.SelectableItemName>,
        onTap: @escaping () -> Void
    ) {
        selectorView.configure(
            selectionState: selectionState,
            onTap: onTap
        )
    }
}

private extension TaxFormSelectorSectionView {
    func configureSubviews() {
        addSubview(section)
        section.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            section.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            section.bottomAnchor.constraint(equalTo: bottomAnchor),
            section.leadingAnchor.constraint(equalTo: leadingAnchor),
            section.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func getSectionContainer(with view: UIView) -> FormSectionContainer {
        return FormSectionContainer(
            containedView: view,
            sectionTitle: sectionTitle
        )
    }
}

