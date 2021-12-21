//
//  OperatorChoiceView.swift
//  PhoneTopUp
//
//  Created by 188216 on 07/12/2021.
//

import UIKit
import UI
import PLUI
import Commons
import PLCommons

final class OperatorSelectionView: UIView {
    // MARK: Views
    
    private let mainContainer = UIStackView()
    private let headerLabel = FormHeaderLabel()
    private let operatorTextField = LisboaTextField()

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
        mainContainer.addArrangedSubview(operatorTextField)
    }
    
    private func prepareStyles() {
        headerLabel.text = localized("pl_topup_text_providName")
        operatorTextField.setRightAccessory(.uiImage(Images.Form.rightChevronIcon, action: {}))
        #warning("remove mock data")
        operatorTextField.setText("Plus (+Mix)")
        operatorTextField.isUserInteractionEnabled = false
    }
    
    private func setUpLayout() {
        mainContainer.axis = .vertical
        mainContainer.spacing = 8.0
        
        NSLayoutConstraint.activate([
            operatorTextField.heightAnchor.constraint(equalToConstant: 48.0),
        ])
    }
}
