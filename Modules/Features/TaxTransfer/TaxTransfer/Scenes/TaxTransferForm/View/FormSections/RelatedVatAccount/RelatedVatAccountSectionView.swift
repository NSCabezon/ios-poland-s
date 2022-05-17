//
//  RelatedVatAccountView.swift
//  TaxTransfer
//
//  Created by 185167 on 10/05/2022.
//

import PLUI
import CoreFoundationLib

final class RelatedVatAccountSectionView: UIView {
    private lazy var sectionContainer = getSectionContainer()
    private let containerView = UIView()
    private let vatAccountBalanceLabel = UILabel()
    private let splitPaymentBackground = UIView()
    private let splitPaymentMessageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(withVatAccountBalanceText vatAccountBalanceText: String) {
        vatAccountBalanceLabel.text = vatAccountBalanceText
    }
}

private extension RelatedVatAccountSectionView {
    func setUp() {
        configureSubviews()
        configureStyling()
        configureStaticTexts()
    }
    
    func configureSubviews() {
        addSubview(sectionContainer)
        sectionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        [vatAccountBalanceLabel, splitPaymentBackground].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        splitPaymentBackground.addSubview(splitPaymentMessageLabel)
        splitPaymentMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            vatAccountBalanceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -4),
            vatAccountBalanceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            vatAccountBalanceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            splitPaymentBackground.topAnchor.constraint(equalTo: vatAccountBalanceLabel.bottomAnchor, constant: 24),
            splitPaymentBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            splitPaymentBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            splitPaymentBackground.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            splitPaymentMessageLabel.topAnchor.constraint(equalTo: splitPaymentBackground.topAnchor, constant: 16),
            splitPaymentMessageLabel.leadingAnchor.constraint(equalTo: splitPaymentBackground.leadingAnchor, constant: 16),
            splitPaymentMessageLabel.trailingAnchor.constraint(equalTo: splitPaymentBackground.trailingAnchor, constant: -16),
            splitPaymentMessageLabel.bottomAnchor.constraint(equalTo: splitPaymentBackground.bottomAnchor, constant: -16),
        ])
    }
    
    func configureStyling() {
        vatAccountBalanceLabel.numberOfLines = 1
        vatAccountBalanceLabel.textColor = .lisboaGray
        vatAccountBalanceLabel.font = .santander(
            family: .micro,
            type: .bold,
            size: 14
        )
        
        splitPaymentMessageLabel.numberOfLines = 0
        splitPaymentMessageLabel.textColor = .lisboaGray
        splitPaymentMessageLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        splitPaymentBackground.backgroundColor = .paleYellow
    }
    
    func configureStaticTexts() {
        splitPaymentMessageLabel.text = "#Przelew podatkowy przy wykorzystaniu mechanizmu płatności podzielonej (Split Payment) wysyłamy z rachunku VAT powiązanego z wybranym rachunkiem rozliczeniowym.\n\nJeśli nie będziesz mieć wystarczającej liczby środków na rachunku VAT, brakującą część płatności pobierzemy z Twojego rachunku rozliczeniowego."
    }
    
    func getSectionContainer() -> FormSectionContainer {
        return FormSectionContainer(
            containedView: containerView,
            sectionTitle: "#Powiązane konto VAT"
        )
    }
}

