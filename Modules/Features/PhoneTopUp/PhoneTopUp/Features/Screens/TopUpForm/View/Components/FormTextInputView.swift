//
//  FormTextInputView.swift
//  PhoneTopUp
//
//  Created by 188216 on 04/05/2022.
//

import UIKit
import UI
import PLUI

class FormTextInputView: UIView {
    // MARK: Views
    
    private let mainContainer = UIStackView()
    let headerLabel = FormHeaderLabel()
    let textField = LisboaTextField()
    let errorLabel = UILabel()

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
        mainContainer.addArrangedSubview(textField)
        mainContainer.addArrangedSubview(errorLabel)
    }
    
    private func prepareStyles() {
        errorLabel.textColor = .santanderRed
        errorLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        clearErrorAppearance()
    }
    
    private func setUpLayout() {
        mainContainer.axis = .vertical
        mainContainer.spacing = 8.0
        headerLabel.setContentHuggingPriority(.required, for: .vertical)
        errorLabel.setContentHuggingPriority(.required, for: .vertical)
        errorLabel.adjustsFontSizeToFitWidth = true
        errorLabel.minimumScaleFactor = 0.5
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 48.0),
        ])
    }
    
    // MARK: Methods
    
    func clearErrorAppearance() {
        headerLabel.textColor = .lisboaGray
        headerLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        errorLabel.isHidden = true
        textField.borders(for: [.bottom], width: 1.0, color: .darkTurqLight)
    }
    
    func setErrorAppearance(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        headerLabel.textColor = .santanderRed
        headerLabel.font = .santander(family: .micro, type: .bold, size: 14.0)
        textField.borders(for: [.bottom], width: 1.0, color: .santanderRed)
    }
}
