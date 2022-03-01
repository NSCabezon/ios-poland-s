//
//  TaxTransferSelectedTaxAuthorityView.swift
//  TaxTransfer
//
//  Created by 185167 on 03/02/2022.
//

import PLUI
import UI

final class TaxTransferSelectedTaxAuthorityView: UIView {
    private let tappableCard = TappableControl()
    private let nameLabel = UILabel()
    private let taxFormSymbolLabel = UILabel()
    private let destinationAccountNumberLabel = UILabel()
    private let stackView = UIStackView()
    private let selectImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        with viewModel: TaxTransferFormViewModel.TaxAuthorityViewModel,
        onTap: @escaping () -> Void
    ) {
        nameLabel.text = viewModel.taxAuthorityName
        taxFormSymbolLabel.attributedText = getAttributedText(
            key: "#Symbol formularza: ",
            value: viewModel.taxFormSymbol
        )
        destinationAccountNumberLabel.attributedText = getAttributedText(
            key: "#Konto: ",
            value: viewModel.destinationAccountNumber
        )
        tappableCard.onTap = onTap
    }
}

private extension TaxTransferSelectedTaxAuthorityView {
    func setUp() {
        configureLabels()
        configureStyling()
        configureSubviews()
    }
    
    func configureSubviews() {
        stackView.isUserInteractionEnabled = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        [nameLabel, taxFormSymbolLabel, destinationAccountNumberLabel].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(tappableCard)
        tappableCard.translatesAutoresizingMaskIntoConstraints = false
        
        [stackView, selectImage].forEach {
            tappableCard.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tappableCard.topAnchor.constraint(equalTo: topAnchor),
            tappableCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            tappableCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            tappableCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: tappableCard.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: tappableCard.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: selectImage.leadingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: tappableCard.bottomAnchor, constant: -16),
            
            selectImage.topAnchor.constraint(greaterThanOrEqualTo: tappableCard.topAnchor, constant: 20),
            selectImage.centerYAnchor.constraint(equalTo: tappableCard.centerYAnchor),
            selectImage.trailingAnchor.constraint(equalTo: tappableCard.trailingAnchor, constant: -24),
            selectImage.bottomAnchor.constraint(lessThanOrEqualTo: tappableCard.bottomAnchor, constant: -20),
            selectImage.widthAnchor.constraint(equalToConstant: 24),
            selectImage.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configureLabels() {
        nameLabel.font = .santander(family: .micro, type: .bold, size: 14)
        
        [nameLabel, taxFormSymbolLabel, destinationAccountNumberLabel].forEach {
            $0.textColor = .black
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
    }
    
    func configureStyling() {
        tappableCard.layer.masksToBounds = false
        tappableCard.backgroundColor = .white
        tappableCard.drawRoundedBorderAndShadow(
            with: .init(color: .lightSanGray, opacity: 0.5, radius: 4, withOffset: 0, heightOffset: 2),
            cornerRadius: 5,
            borderColor: .mediumSkyGray,
            borderWith: 1
        )
        
        selectImage.image = Images.Common.chevron
    }

    func getAttributedText(key: String, value: String) -> NSAttributedString {
        guard !value.isEmpty else { return NSAttributedString() }
        
        let attributedKey = NSMutableAttributedString(string: key)
        attributedKey.addAttribute(.font(.santander(family: .micro, type: .regular, size: 12)))

        let attributedValue = NSMutableAttributedString(string: value)
        attributedValue.addAttribute(.font(.santander(family: .micro, type: .bold, size: 12)))

        attributedKey.append(attributedValue)

        return attributedKey
    }
}

