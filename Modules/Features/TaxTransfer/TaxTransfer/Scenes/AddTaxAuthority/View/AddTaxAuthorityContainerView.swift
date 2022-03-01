//
//  AddTaxAuthorityContainerView.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import CoreFoundationLib
import UI
import PLUI

protocol AddTaxAuthorityContainerViewDelegate: AnyObject {
    func didUpdateFields()
}

final class AddTaxAuthorityContainerView: UIView {
    private let stackView = UIStackView()
    private let editableTaxAccountView = EditableTaxAccountView()
    private let nonEditableTaxAccountView = NonEditableTaxAccountView()
    private let irpWarningView = IrpWarningSectionView()
    private let taxFormSymbolSelectorView = TaxFormSelectorSectionView(
        sectionTitle: "#Symbol formularza:"
    )
    private let citySelectorView = TaxFormSelectorSectionView(
        sectionTitle: "#Miasto:"
    )
    private let taxAuthorityNameSelectorView = TaxFormSelectorSectionView(
        sectionTitle: "#Nazwa organu:"
    )
    
    private weak var delegate: AddTaxAuthorityContainerViewDelegate?
    
    init(
        delegate: AddTaxAuthorityContainerViewDelegate
    ) {
        self.delegate = delegate
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
}

private extension AddTaxAuthorityContainerView {
    func setUp() {
        configureStackView()
        configureSubviews()
    }
    
    func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
    }
    
    func configureSubviews() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            taxFormSymbolSelectorView,
            citySelectorView,
            taxAuthorityNameSelectorView,
            nonEditableTaxAccountView,
            irpWarningView
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
