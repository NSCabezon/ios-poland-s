//
//  TermsAndConditionsView.swift
//  PhoneTopUp
//
//  Created by 188216 on 10/12/2021.
//

import UIKit
import UI
import PLUI
import Commons
import PLCommons

final class TermsAndConditionsView: UIView {
    // MARK: Views
    
    private let mainContainer = UIStackView()
    private let termsContainer = UIStackView()
    private let checkBoxContainer = UIStackView()
    private let expandOrFoldButton = UIButton()
    private let termsLabel = UILabel()
    private let checkBoxButton = UIButton()
    private var isExpanded = false
    private var isChecked = false
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Configuration
    
    private func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
        setUpActions()
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(mainContainer)
        
        mainContainer.addArrangedSubview(termsContainer)
        mainContainer.addArrangedSubview(expandOrFoldButton)
        
        termsContainer.addArrangedSubview(checkBoxContainer)
        termsContainer.addArrangedSubview(termsLabel)
        
        checkBoxContainer.addArrangedSubview(checkBoxButton)
        checkBoxContainer.addArrangedSubview(UIView())
    }
    
    private func setUpLayout() {
        mainContainer.axis = .vertical
        termsContainer.axis = .horizontal
        termsContainer.spacing = 8.0
        checkBoxContainer.axis = .vertical
        
        NSLayoutConstraint.activate([
            checkBoxContainer.widthAnchor.constraint(equalToConstant: 24.0),
            expandOrFoldButton.heightAnchor.constraint(equalToConstant: 30),
            checkBoxButton.widthAnchor.constraint(equalTo: checkBoxButton.heightAnchor)
        ])
    }
    
    private func prepareStyles() {
        termsLabel.text = localized("pl_topup_text_statementRegulations")
        termsLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        termsLabel.textColor = .lisboaGray
        
        expandOrFoldButton.titleLabel?.font = .santander(family: .micro, type: .bold, size: 14.0)
        expandOrFoldButton.contentHorizontalAlignment = .right
        expandOrFoldButton.setTitleColor(.darkTorquoise, for: .normal)
        
        
        checkBoxButton.contentHorizontalAlignment = .fill
        checkBoxButton.contentVerticalAlignment = .fill
        checkBoxButton.imageEdgeInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
        
        if isExpanded {
            expandOrFoldButton.setTitle(localized("pl_topup_link_foldTextRegulations"), for: .normal)
            termsLabel.numberOfLines = 0
        } else {
            expandOrFoldButton.setTitle(localized("pl_topup_link_fullTextRegulations"), for: .normal)
            termsLabel.numberOfLines = 2
        }
        
        let checkBoxShadowConfiguration = ShadowConfiguration(
            color: .lightSanGray.withAlphaComponent(0.6),
            opacity: 1.0,
            radius: 2.0,
            withOffset: 0,
            heightOffset: 2
        )
        
        if isChecked {
            checkBoxButton.drawRoundedBorderAndShadow(
                with: checkBoxShadowConfiguration,
                cornerRadius: 4.0,
                borderColor: .darkTorquoise,
                borderWith: 1.0
            )
            checkBoxButton.backgroundColor = .darkTorquoise
            checkBoxButton.setImage(Images.Form.tickIcon, for: .normal)
        } else {
            checkBoxButton.drawRoundedBorderAndShadow(
                with: checkBoxShadowConfiguration,
                cornerRadius: 4.0,
                borderColor: .mediumSky,
                borderWith: 1.0
            )
            checkBoxButton.backgroundColor = .white
            checkBoxButton.setImage(nil, for: .normal)
        }
    }
    
    private func setUpActions() {
        expandOrFoldButton.addTarget(self, action: #selector(didTouchExpandOrFoldButton), for: .touchUpInside)
        checkBoxButton.addTarget(self, action: #selector(didTouchCheckBoxButton), for: .touchUpInside)
    }
    
    @objc
    private func didTouchExpandOrFoldButton() {
        isExpanded.toggle()
        prepareStyles()
    }
    
    @objc
    private func didTouchCheckBoxButton() {
        isChecked.toggle()
        prepareStyles()
    }
}
