//
//  TaxTransferElementSelectorView.swift
//  TaxTransfer
//
//  Created by 185167 on 28/12/2021.
//

import PLUI

final class TaxTransferElementSelectorView: UIView {
    private let tappableCard = TappableControl()
    private let selectLabel = UILabel()
    private let selectImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func configure(onTap: @escaping () -> Void) {
        tappableCard.onTap = onTap
    }
}

private extension TaxTransferElementSelectorView {
    func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    func configureSubviews() {
        addSubview(tappableCard)
        tappableCard.translatesAutoresizingMaskIntoConstraints = false
        
        [selectLabel, selectImage].forEach {
            tappableCard.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tappableCard.topAnchor.constraint(equalTo: topAnchor),
            tappableCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            tappableCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            tappableCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            selectLabel.centerYAnchor.constraint(equalTo: selectImage.centerYAnchor),
            selectLabel.leadingAnchor.constraint(equalTo: tappableCard.leadingAnchor, constant: 16),
            selectLabel.trailingAnchor.constraint(equalTo: selectImage.leadingAnchor, constant: -16),
            
            selectImage.topAnchor.constraint(equalTo: tappableCard.topAnchor, constant: 20),
            selectImage.centerYAnchor.constraint(equalTo: tappableCard.centerYAnchor),
            selectImage.trailingAnchor.constraint(equalTo: tappableCard.trailingAnchor, constant: -24),
            selectImage.bottomAnchor.constraint(equalTo: tappableCard.bottomAnchor, constant: -20),
            selectImage.widthAnchor.constraint(equalToConstant: 24),
            selectImage.heightAnchor.constraint(equalToConstant: 24)
        ])
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
        
        selectLabel.text = "#Wybierz"
        selectLabel.numberOfLines = 1
        selectLabel.textColor = .lisboaGray
        selectLabel.font = .santander(
            family: .micro,
            type: .bold,
            size: 14
        )
    }
}
