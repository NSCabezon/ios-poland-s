//
//  RecipientNameView.swift
//  PhoneTopUp
//
//  Created by 188216 on 07/12/2021.
//

import Commons
import PLCommons
import UIKit
import PLUI
import UI

final class RecipientNameView: UIView {
    // MARK: Views
    
    private let mainContainer = UIStackView()
    private let headerLabel = FormHeaderLabel()
    private let nameTextField = LisboaTextField()

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
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(mainContainer)
        
        mainContainer.addArrangedSubview(headerLabel)
        mainContainer.addArrangedSubview(nameTextField)
    }
    
    private func prepareStyles() {
        headerLabel.text = localized("pl_topup_text_recipName")
        nameTextField.isUserInteractionEnabled = false
    }
    
    private func setUpLayout() {
        mainContainer.axis = .vertical
        mainContainer.spacing = 8.0
        
        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: 48.0)
        ])
    }
    
    // MARK: Methods
    
    func setUp(with name: String) {
        nameTextField.setText(name)
    }
}
