//
//  MenuItemView.swift
//  BLIK
//
//  Created by 186492 on 07/06/2021.
//

import UIKit
import PLCommons
import PLUI

class MenuItemView: UIView {
    private let stackView = UIStackView()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lisboaGray
        label.font = .santander(family: .text, type: .bold, size: 16)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brownishGray
        label.font = .santander(family: .text, type: .regular, size: 12)
        return label
    }()
    
    private let disclosureIndicator: UIImageView = {
        let iv = UIImageView(image: Images.chevron)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var onTapped: (() -> Void)?
    
    init(model: MenuViewModel) {
        super.init(frame: .zero)
        setup()
        
        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MenuItemView {
    func setup() {
        prepareSubviews()
        prepareStyles()
        prepareActions()
        prepareLayout()
        setIdentifiers()
    }
    
    func prepareSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(VStackView([titleLabel, descriptionLabel], spacing: 2))
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(disclosureIndicator)
    }
    
    func prepareStyles() {
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.backgroundColor = .white
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 14, left: 16, bottom: 14, right: 16)
        
        drawRoundedBorderAndShadow(
            with: .init(color: .skyGray, opacity: 1, radius: 1, withOffset: 0, heightOffset: 4),
            cornerRadius: 4,
            borderColor: .mediumSkyGray,
            borderWith: 1
        )
    }
    
    func prepareActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
    }
    
    func prepareLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 22),
            
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc
    func selfTapped() {
        onTapped?()
    }
    
    func setIdentifiers() {
        imageView.accessibilityIdentifier = AccessibilityBLIK.MenuView.imageView.id
        titleLabel.accessibilityIdentifier = AccessibilityBLIK.MenuView.titleLabel.id
        descriptionLabel.accessibilityIdentifier = AccessibilityBLIK.MenuView.descriptionLabel.id
        disclosureIndicator.accessibilityIdentifier = AccessibilityBLIK.MenuView.disclosureIndicator.id
    }
}
