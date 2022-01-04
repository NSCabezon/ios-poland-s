//
//  PhoneTopUpFormView.swift
//  PhoneTopUp
//
//  Created by 188216 on 02/12/2021.
//

import UIKit
import UI
import PLUI
import Commons

protocol PhoneTopUpFormViewDelegate: AnyObject {
    func topUpFormDidSelectChangeAccount()
}

final class PhoneTopUpFormView: UIView {
    // MARK: Properties
    
    weak var delegate: PhoneTopUpFormViewDelegate?
    private let contentScrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let selectedAccountSectionContainer = UIStackView()
    private let selectedAccountHeaderLabel = FormHeaderLabel()
    private let selectedAccountView = SelectedAccountView()
    private let phoneNumberInputView = PhoneNumberInputView()
    private let recipientNameView = RecipientNameView()
    private let operatorSelectionView = OperatorSelectionView()
    private let amountSelectionView = PaymentAmountSelectionView()
    private let termsAndConditionsView = TermsAndConditionsView()
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    // MARK: Configuration
    
    private func setUp() {
        addSubviews()
        setUpLayout()
        prepareStyles()
        prepareSelectAccountView()
    }

    private func addSubviews() {
        addSubviewConstraintToEdges(contentScrollView)
        
        contentScrollView.addSubviewConstraintToEdges(contentStackView)
        
        contentStackView.addArrangedSubview(selectedAccountSectionContainer)
        contentStackView.addArrangedSubview(phoneNumberInputView)
        contentStackView.addArrangedSubview(recipientNameView)
        contentStackView.addArrangedSubview(operatorSelectionView)
        contentStackView.addArrangedSubview(amountSelectionView)
        contentStackView.addArrangedSubview(termsAndConditionsView)
        
        selectedAccountSectionContainer.addArrangedSubview(selectedAccountHeaderLabel)
        selectedAccountSectionContainer.addArrangedSubview(selectedAccountView)
    }
    
    private func setUpLayout() {
        contentStackView.axis = .vertical
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        contentStackView.spacing = 24.0
        selectedAccountSectionContainer.axis = .vertical
        selectedAccountSectionContainer.spacing = 8.0
        
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
        ])
    }
    
    private func prepareStyles() {
        selectedAccountHeaderLabel.text = localized("pl_topup_text_sendAccount")
    }
    
    private func prepareSelectAccountView() {
        selectedAccountView.setChangeAction { [weak self] in
            self?.delegate?.topUpFormDidSelectChangeAccount()
        }
    }
    
    // MARK: Methods
    
    func updateSelectedAccount(with accountModels: [SelectableAccountViewModel]) {
        selectedAccountView.setViewModel(accountModels)
    }
}
