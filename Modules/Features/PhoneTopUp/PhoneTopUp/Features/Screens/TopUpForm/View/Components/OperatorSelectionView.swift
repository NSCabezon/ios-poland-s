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

protocol OperatorSelectionViewDelegate: AnyObject {
    func didTouchOperatorSelectionButton()
}

final class OperatorSelectionView: UIView {
    // MARK: Views
    
    weak var delegate: OperatorSelectionViewDelegate?
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
    
    func setUp(with gsmOperator: GSMOperator?) {
        isHidden = gsmOperator == nil
        operatorTextField.setText(gsmOperator?.name)
    }
    
    private func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
        operatorTextField.fieldDelegate = self
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(mainContainer)
        mainContainer.addArrangedSubview(headerLabel)
        mainContainer.addArrangedSubview(operatorTextField)
    }
    
    private func prepareStyles() {
        headerLabel.text = localized("pl_topup_text_providName")
        operatorTextField.setRightAccessory(.uiImage(Images.Form.rightChevronIcon, action: { [weak self] in
            self?.delegate?.didTouchOperatorSelectionButton()
        }))
    }
    
    private func setUpLayout() {
        mainContainer.axis = .vertical
        mainContainer.spacing = 8.0
        
        NSLayoutConstraint.activate([
            operatorTextField.heightAnchor.constraint(equalToConstant: 48.0),
        ])
    }
}

extension OperatorSelectionView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
