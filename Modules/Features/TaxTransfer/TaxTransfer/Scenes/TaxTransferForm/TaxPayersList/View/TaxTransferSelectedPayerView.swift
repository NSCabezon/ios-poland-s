//
//  TaxTransferSelectedPayerView.swift
//  TaxTransfer
//
//  Created by 187831 on 10/01/2022.
//

import PLUI
import UI
import CoreFoundationLib

final class TaxTransferSelectedPayerView: UIView {
    private let tappableCard = TappableControl()
    private let nameLabel = UILabel()
    private let taxIdentifierTypeLabel = UILabel()
    private let taxIdentifierNumberLabel = UILabel()
    private let taxInfoStackView = UIStackView()
    private let selectImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: TaxTransferFormViewModel.TaxPayerViewModel, onTap: @escaping () -> Void) {
        nameLabel.text = viewModel.taxPayer.name
        tappableCard.onTap = onTap
        
        guard let taxIdentifier = viewModel.selectedInfo?.taxIdentifier,
              let value = viewModel.selectedInfo?.idType.displayableValue else { return }
        
        taxIdentifierNumberLabel.attributedText = getAttributedText(
            key: localized("pl_taxTransfer_text_identifierNumber"),
            value: taxIdentifier
        )
        taxIdentifierTypeLabel.attributedText = getAttributedText(
            key: localized("pl_taxTransfer_text_identifierType"),
            value: value
        )
    }
}

private extension TaxTransferSelectedPayerView {
    func setUp() {
        configureSubviews()
        configureLabels()
        configureStyling()
    }
    
    func configureSubviews() {
        taxInfoStackView.isUserInteractionEnabled = false
        taxInfoStackView.axis = .vertical
        taxInfoStackView.distribution = .equalSpacing
        taxInfoStackView.spacing = 4
        [
            nameLabel,
            taxIdentifierTypeLabel,
            taxIdentifierNumberLabel
        ].forEach {
            taxInfoStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(tappableCard)
        tappableCard.translatesAutoresizingMaskIntoConstraints = false
        
        [taxInfoStackView, selectImage].forEach {
            tappableCard.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tappableCard.topAnchor.constraint(equalTo: topAnchor),
            tappableCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            tappableCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            tappableCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            taxInfoStackView.topAnchor.constraint(equalTo: tappableCard.topAnchor, constant: 16),
            taxInfoStackView.leadingAnchor.constraint(equalTo: tappableCard.leadingAnchor, constant: 16),
            taxInfoStackView.trailingAnchor.constraint(equalTo: selectImage.leadingAnchor, constant: -16),
            taxInfoStackView.bottomAnchor.constraint(equalTo: tappableCard.bottomAnchor, constant: -16),
            
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
        
        [nameLabel,
        taxIdentifierNumberLabel,
        taxIdentifierTypeLabel].forEach {
            $0.textColor = .black
            $0.textAlignment = .left
        }
    }
    
    func configureStyling() {
        tappableCard.layer.masksToBounds = false
        tappableCard.backgroundColor = .clear
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
        attributedKey.append(.init(string: ": "))

        let attributedValue = NSMutableAttributedString(string: value)
        attributedValue.addAttribute(.font(.santander(family: .micro, type: .bold, size: 12)))

        attributedKey.append(attributedValue)

        return attributedKey
    }
}
