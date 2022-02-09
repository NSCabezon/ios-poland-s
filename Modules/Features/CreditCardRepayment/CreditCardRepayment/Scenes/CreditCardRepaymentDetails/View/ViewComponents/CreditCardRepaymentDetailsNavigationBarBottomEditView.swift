//
//  CreditCardRepaymentDetailsNavigationBarBottomEditView.swift
//  CreditCardRepayment
//
//  Created by 186484 on 23/06/2021.
//

import Foundation
import CoreFoundationLib
import UI

private enum Constants {
    // StackView
    static let stackViewSpacing: CGFloat = 0
}

extension CreditCardRepaymentDetailsView {
    final class NavigationBarEditView: UIView {
        
        private let horizontalStackView = UIStackView()
        private let verticalStackView = UIStackView()
        
        var isEditVisible: Bool = true {
            didSet { updateRightView(isEditVisible) }
        }
        
        var onTouchAction: ((_ sender: ImageButton) -> Void)? {
            didSet {
                editButton.onTouchAction = onTouchAction
            }
        }
        
        private var topLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            let labelStylist = LabelStylist(textColor: .brownishGray,
                                            font: .santander(family: .micro, type: .bold, size: 11.0),
                                            textAlignment: .left)
            label.applyStyle(labelStylist)
            return label
        }()
        
        private var bottomLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.setContentHuggingPriority(.defaultLow - 1, for: .vertical)
            let labelStylist = LabelStylist(textColor: .brownishGray,
                                            font: .santander(family: .micro, type: .bold, size: 14.0),
                                            textAlignment: .left)
            label.applyStyle(labelStylist)
            return label
        }()
        
        private lazy var separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .brownishGray
            return view
        }()
        
        private lazy var changeViewContainer: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }()
        
        private var editButton: ImageButton = ImageButton()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setUp()
        }
        
        private func updateRightView(_ isVisible: Bool) {
            editButton.isHidden = !isVisible
            separatorView.isHidden = !isVisible
        }
        
        func setup(topText: String, bottomText: String) {
            topLabel.text = topText
            bottomLabel.text = bottomText
        }
        
        private func setUp() {
            setUpStackView()
            setUpStyles()
            setUpLayouts()
        }
        
        private func setUpStackView() {
            changeViewContainer.addSubview(editButton)
            
            verticalStackView.addArrangedSubview(topLabel)
            verticalStackView.addArrangedSubview(bottomLabel)
            
            horizontalStackView.addArrangedSubview(verticalStackView)
            horizontalStackView.addArrangedSubview(separatorView)
            horizontalStackView.addArrangedSubview(changeViewContainer)
            
            addSubview(horizontalStackView)
        }
        
        private func setUpStyles() {
            setUpEditButtonStyles()
            setUpVerticalStackViewStyles()
            setUpHorizontalStackViewViewStyles()
            backgroundColor = .clear
        }
        
        private func setUpEditButtonStyles() {
            editButton.setTitleColor(.greyBlue, for: .normal)
            editButton.titleLabel?.font =  .santander(family: .micro, type: .bold, size: 9.0)
            editButton.setTitle(localized("generic_button_change"), for: .normal)
            editButton.setImage(Images.penEdit, for: .normal)
        }
        
        private func setUpVerticalStackViewStyles() {
            verticalStackView.axis = .vertical
            verticalStackView.alignment = .fill
            verticalStackView.spacing = Constants.stackViewSpacing
            verticalStackView.distribution = .fill
        }
        
        private func setUpHorizontalStackViewViewStyles() {
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.spacing = Constants.stackViewSpacing
            horizontalStackView.distribution = .fill
        }
        
        private func setUpLayouts() {
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            changeViewContainer.translatesAutoresizingMaskIntoConstraints = false
            editButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
                horizontalStackView.leftAnchor.constraint(equalTo: leftAnchor),
                horizontalStackView.rightAnchor.constraint(equalTo: rightAnchor),
                horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                separatorView.widthAnchor.constraint(equalToConstant: 1),
                
                changeViewContainer.widthAnchor.constraint(equalToConstant: 50.0),
                
                editButton.leftAnchor.constraint(equalTo: changeViewContainer.leftAnchor),
                editButton.rightAnchor.constraint(equalTo: changeViewContainer.rightAnchor),
                editButton.centerYAnchor.constraint(equalTo: changeViewContainer.centerYAnchor)
            ])
        }
        
    }
    
}
