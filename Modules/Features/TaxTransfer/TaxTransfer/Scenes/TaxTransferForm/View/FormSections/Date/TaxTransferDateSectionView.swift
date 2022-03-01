//
//  TaxTransferDateSectionView.swift
//  PLUI
//
//  Created by 185167 on 03/01/2022.
//

import PLUI

final class TaxTransferDateSectionView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let dateSelector: TransferDateSelector
    weak var delegate: TransferDateSelectorDelegate? {
        didSet {
            dateSelector.delegate = delegate
        }
    }
    
    init(configuration: TaxFormConfiguration.DateSelectorConfiguration) {
        self.dateSelector = TransferDateSelector(
            language: configuration.language,
            dateFormatter: configuration.dateFormatter
        )
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func getSelectedDate() -> Date {
        return dateSelector.getSelectedDate()
    }
}

private extension TaxTransferDateSectionView {
    func setUp() {
        configureSubviews()
    }
    
    func configureSubviews() {
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: dateSelector,
            sectionTitle: "#Kiedy mamy wysłać ten przelew?"
        )
    }
}
