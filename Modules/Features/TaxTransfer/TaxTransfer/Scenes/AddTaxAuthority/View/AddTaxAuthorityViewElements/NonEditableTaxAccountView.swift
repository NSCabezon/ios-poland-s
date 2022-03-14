//
//  NonEditableTaxAccountView.swift
//  TaxTransfer
//
//  Created by 185167 on 22/02/2022.
//

import CoreFoundationLib
import UI
import PLUI

final class NonEditableTaxAccountView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let containerView = UIView()
    private let accountNumberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(with accountNumber: String) {
        accountNumberLabel.text = accountNumber
    }
}

private extension NonEditableTaxAccountView {
    func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    func configureSubviews() {
        containerView.addSubview(accountNumberLabel)
        accountNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            accountNumberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            accountNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            accountNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            accountNumberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            containerView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: containerView,
            sectionTitle: "#Numer rachunku/ aka Konto"
        )
    }
    
    func configureStyling() {
        containerView.backgroundColor = .lightSanGray
        
        accountNumberLabel.numberOfLines = 1
        accountNumberLabel.textColor = .brownishGray
        accountNumberLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 16
        )
    }
}
