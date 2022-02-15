//
//  TaxTransferSelectedPayerView.swift
//  TaxTransfer
//
//  Created by 187831 on 10/01/2022.
//

import PLUI
import UI

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
        taxIdentifierNumberLabel.attributedText = getAttributedText(key: "#Numer identyfikatora: ",
                                                                    value: viewModel.selectedInfo.taxIdentifier)
        taxIdentifierTypeLabel.attributedText = getAttributedText(key: "#Typ idenyfikatora: ",
                                                                  value: viewModel.selectedInfo.idType.displayableValue)
        tappableCard.onTap = onTap
    }
}

private extension TaxTransferSelectedPayerView {
    func setUp() {
        configureSubviews()
        configureLabels()
        configureStyling()
    }
    
    func configureSubviews() {
        addSubview(taxInfoStackView)
        taxInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        taxInfoStackView.axis = .vertical
        taxInfoStackView.distribution = .equalSpacing

        addSubview(selectImage)
        selectImage.translatesAutoresizingMaskIntoConstraints = false
        
        [nameLabel,
        taxIdentifierTypeLabel,
        taxIdentifierNumberLabel].forEach {
            taxInfoStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(tappableCard)
        tappableCard.translatesAutoresizingMaskIntoConstraints = false
        
        bringSubviewToFront(tappableCard)
        
        NSLayoutConstraint.activate([
            tappableCard.topAnchor.constraint(equalTo: topAnchor),
            tappableCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            tappableCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            tappableCard.heightAnchor.constraint(equalToConstant: 95),

            selectImage.centerYAnchor.constraint(equalTo: tappableCard.centerYAnchor),
            selectImage.trailingAnchor.constraint(equalTo: tappableCard.trailingAnchor, constant: -24),
            selectImage.widthAnchor.constraint(equalToConstant: 24),
            selectImage.heightAnchor.constraint(equalToConstant: 24),

            taxInfoStackView.topAnchor.constraint(equalTo: tappableCard.topAnchor, constant: 15),
            taxInfoStackView.leadingAnchor.constraint(equalTo: tappableCard.leadingAnchor, constant: 15),
            taxInfoStackView.trailingAnchor.constraint(equalTo: selectImage.trailingAnchor, constant: 15),
            taxInfoStackView.bottomAnchor.constraint(equalTo: tappableCard.bottomAnchor, constant: -15)
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

        let attributedValue = NSMutableAttributedString(string: value)
        attributedValue.addAttribute(.font(.santander(family: .micro, type: .bold, size: 12)))

        attributedKey.append(attributedValue)

        return attributedKey
    }
}
