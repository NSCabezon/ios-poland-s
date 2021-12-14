//
//  BLIKConfirmationAliasInfoBanner.swift
//  BLIK
//
//  Created by 185167 on 17/11/2021.
//

import UI

final class BLIKConfirmationAliasInfoBannerView: UIView {
    private let infoIcon = UIImageView()
    private let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
}

private extension BLIKConfirmationAliasInfoBannerView {
    func setUp() {
        configureSubviews()
        configureStyling()
        configureStaticTexts()
    }
    
    func configureSubviews() {
        [infoIcon, infoLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            infoIcon.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            infoIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoIcon.heightAnchor.constraint(equalToConstant: 48),
            infoIcon.widthAnchor.constraint(equalToConstant: 48),
            
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            infoLabel.leadingAnchor.constraint(equalTo: infoIcon.trailingAnchor, constant: 12),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ])
    }
    
    func configureStyling() {
        backgroundColor = .white
        infoIcon.image = Images.info_yellow
        
        infoLabel.textColor = .lisboaGray
        infoLabel.numberOfLines = 0
        infoLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        addShadow(
            location: .top,
            color: .lightSanGray,
            opacity: 0.4,
            radius: 3,
            height: 1
        )
    }
    
    func configureStaticTexts() {
        infoLabel.text = "#Płatność została zrealizowana bez konieczności podawania kodu BLIK, ponieważ była zrealizowana za pomocą Zakupów bez kodu."
    }
}
