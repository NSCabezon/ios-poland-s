//
//  PaymentAmountCollectionViewCell.swift
//  PhoneTopUp
//
//  Created by 188216 on 08/12/2021.
//

import CoreFoundationLib
import UIKit
import UI
import PLUI

final class PaymentAmountCollectionViewCell: UICollectionViewCell {
    // MARK: Views
    
    private let decorativeView = UIView()
    private let mainContainer = UIView()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tickView = TickView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Configuration
    
    func setUp(with cellModel: PaymentAmountCellViewModel) {
        switch cellModel {
        case .custom(let minAmount, let maxAmount, let isSelected):
            titleLabel.text = localized("pl_topup_button_otherAmount")
            subtitleLabel.text = "(\(minAmount)-\(maxAmount))"
            subtitleLabel.isHidden = false
            setStyle(isSelected: isSelected)
        case .fixed(let topUpValue, let isSelected):
            titleLabel.text = "\(topUpValue.value)"
            subtitleLabel.text = "+\(topUpValue.bonus)"
            subtitleLabel.isHidden = topUpValue.bonus == 0
            setStyle(isSelected: isSelected)
        }
    }
    
    private func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(decorativeView)
        addSubviewConstraintToEdges(mainContainer)
        
        mainContainer.addSubview(tickView)
        mainContainer.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
    }
    
    private func prepareStyles() {
        setStyle(isSelected: false)
        titleLabel.font = .santander(family: .micro, type: .bold, size: 16.0)
        subtitleLabel.font = .santander(family: .micro, type: .regular, size: 12.0)
    }
    
    private func setUpLayout() {
        contentStackView.axis = .vertical
        
        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
        
        tickView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tickView.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: -8.0),
            tickView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: 8.0),
            contentStackView.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor),
        ])
    }
    
    func setStyle(isSelected: Bool) {
        let decorativeViewShadowConfiguration = ShadowConfiguration(
            color: .lightSanGray.withAlphaComponent(0.6),
            opacity: 1.0,
            radius: 2.0,
            withOffset: 0,
            heightOffset: 2
        )
        
        if isSelected {
            decorativeView.backgroundColor = .sky
            decorativeView.drawRoundedBorderAndShadow(
                with: decorativeViewShadowConfiguration,
                cornerRadius: 8.0,
                borderColor: .darkTorquoise,
                borderWith: 1.0
            )
            tickView.isHidden = false
            [titleLabel, subtitleLabel].forEach { label in
                label.textColor = .darkTorquoise
            }
        } else {
            decorativeView.backgroundColor = .white
            decorativeView.drawRoundedBorderAndShadow(
                with: decorativeViewShadowConfiguration,
                cornerRadius: 8.0,
                borderColor: .mediumSkyGray,
                borderWith: 1.0
            )
            tickView.isHidden = true
            [titleLabel, subtitleLabel].forEach { label in
                label.textColor = .lisboaGray
            }
        }
    }
}
