//
//  PaymentAmountCollectionViewCell.swift
//  PhoneTopUp
//
//  Created by 188216 on 08/12/2021.
//

import UIKit
import UI
import PLUI

final class PaymentAmountCollectionViewCell: UICollectionViewCell {
    enum Style {
        case selected
        case unselected
    }
    // MARK: Views
    
    private let decorativeView = UIView()
    private let mainContainer = UIView()
    private let contentStackView = UIStackView()
    private let amountLabel = UILabel()
    private let bonusLabel = UILabel()
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
    
    func setUp(with topUpValue: TopUpValue, isSelected: Bool) {
        amountLabel.text = "\(topUpValue.value)"
        bonusLabel.text = "+\(topUpValue.bonus)"
        bonusLabel.isHidden = topUpValue.bonus == 0
        let style: Style = isSelected ? .selected : .unselected
        setStyle(style)
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
        
        contentStackView.addArrangedSubview(amountLabel)
        contentStackView.addArrangedSubview(bonusLabel)
    }
    
    private func prepareStyles() {
        setStyle(.unselected)
        amountLabel.font = .santander(family: .micro, type: .bold, size: 16.0)
        bonusLabel.font = .santander(family: .micro, type: .regular, size: 12.0)
        #warning("todo: remove mock values")
        amountLabel.text = "30"
        bonusLabel.text = "(+10)"
    }
    
    private func setUpLayout() {
        contentStackView.axis = .vertical
        
        amountLabel.textAlignment = .center
        bonusLabel.textAlignment = .center
        
        tickView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tickView.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: -8.0),
            tickView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: 8.0),
            contentStackView.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor),
        ])
    }
    
    func setStyle(_ style: Style) {
        let decorativeViewShadowConfiguration = ShadowConfiguration(
            color: .lightSanGray.withAlphaComponent(0.6),
            opacity: 1.0,
            radius: 2.0,
            withOffset: 0,
            heightOffset: 2
        )
        
        switch style {
        case .selected:
            decorativeView.backgroundColor = .sky
            decorativeView.drawRoundedBorderAndShadow(
                with: decorativeViewShadowConfiguration,
                cornerRadius: 8.0,
                borderColor: .darkTorquoise,
                borderWith: 1.0
            )
            tickView.isHidden = false
            [amountLabel, bonusLabel].forEach { label in
                label.textColor = .darkTorquoise
            }
        case .unselected:
            decorativeView.backgroundColor = .white
            decorativeView.drawRoundedBorderAndShadow(
                with: decorativeViewShadowConfiguration,
                cornerRadius: 8.0,
                borderColor: .mediumSkyGray,
                borderWith: 1.0
            )
            tickView.isHidden = true
            [amountLabel, bonusLabel].forEach { label in
                label.textColor = .lisboaGray
            }
        }
    }
}
