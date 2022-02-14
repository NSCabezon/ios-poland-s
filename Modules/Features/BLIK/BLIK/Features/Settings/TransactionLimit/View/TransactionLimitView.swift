import UIKit
import UI
import PLUI
import CoreFoundationLib

protocol TransactionLimitViewDelegate: AnyObject {
    func didUpdateLimit()
}

final class TransactionLimitView: UIView {
    private let limitsTitleLabel = UILabel()
    private let withdrawLimitTextField = LisboaTextFieldWithErrorView()
    private let withdrawLimitAccessoryView = CurrencyLabel()
    private let withdrawLimitHintLabel = UILabel()
    private let purchaseLimitTextField = LisboaTextFieldWithErrorView()
    private let purchaseLimitAccessoryView = CurrencyLabel()
    private let purchaseLimitHintLabel = UILabel()
    private let chequeBlikTitleLabel = UILabel()
    private let chequeBlikLimitLabel = UILabel()
    private let chequeBlikLimitValueLabel = UILabel()
    public weak var delegate: TransactionLimitViewDelegate?
    
    public var withdrawLimit: String? {
        withdrawLimitTextField.textField.text
    }
    
    public var purchaseLimit: String? {
        purchaseLimitTextField.textField.text
    }
    
    public init() {
        super.init(frame: .zero)
        configureSubviews()
        configureStyling()
        configureContent()
        configureDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: TransactionLimitViewModel) {
        chequeBlikLimitValueLabel.text = viewModel.chequeBlikLimitValue
        withdrawLimitAccessoryView.setText(viewModel.limitCurrency)
        purchaseLimitAccessoryView.setText(viewModel.limitCurrency)
        withdrawLimitHintLabel.text = viewModel.withdrawLimitText
        purchaseLimitHintLabel.text = viewModel.purchaseLimitText
        purchaseLimitTextField.textField.setText(viewModel.purchaseLimitValue)
        withdrawLimitTextField.textField.setText(viewModel.withdrawLimitValue)
    }
    
    func showInvalidFormMessage(_ error: InvalidLimitFormMessages) {
        if error.invalidPurchaseLimitMessage == nil {
            purchaseLimitTextField.hideError()
        } else {
            purchaseLimitTextField.showError(error.invalidPurchaseLimitMessage)
        }
        
        if error.invalidWithdrawLimitMessage == nil {
            withdrawLimitTextField.hideError()
        } else {
            withdrawLimitTextField.showError(error.invalidWithdrawLimitMessage)
        }
    }
    
    func clearValidationMessages() {
        purchaseLimitTextField.hideError()
        withdrawLimitTextField.hideError()
    }
}

private extension TransactionLimitView {
    
    func configureContent() {
        limitsTitleLabel.text = localized("pl_blik_text_limitDaily")
        withdrawLimitTextField.textField.setPlaceholder(localized("pl_blik_label_limitCash"))
        purchaseLimitTextField.textField.setPlaceholder(localized("pl_blik_label_limitStores"))
        chequeBlikTitleLabel.text = localized("pl_blik_text_chequeLimit")
        chequeBlikLimitLabel.text = localized("pl_blik_text_oneChequeLimit")
    }
    
    func configureDelegates() {
        withdrawLimitTextField.textField.updatableDelegate = self
        purchaseLimitTextField.textField.updatableDelegate = self
    }
    
    func configureSubviews() {
        [limitsTitleLabel,
         withdrawLimitTextField,
         withdrawLimitHintLabel,
         purchaseLimitTextField,
         purchaseLimitHintLabel,
         chequeBlikTitleLabel,
         chequeBlikLimitLabel,
         chequeBlikLimitValueLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            limitsTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            limitsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            limitsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            withdrawLimitTextField.topAnchor.constraint(equalTo: limitsTitleLabel.bottomAnchor, constant: 16),
            withdrawLimitTextField.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            withdrawLimitTextField.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            
            withdrawLimitHintLabel.topAnchor.constraint(equalTo: withdrawLimitTextField.bottomAnchor, constant: 8),
            withdrawLimitHintLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            withdrawLimitHintLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),

            purchaseLimitTextField.topAnchor.constraint(equalTo: withdrawLimitHintLabel.bottomAnchor, constant: 16),
            purchaseLimitTextField.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            purchaseLimitTextField.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            
            purchaseLimitHintLabel.topAnchor.constraint(equalTo: purchaseLimitTextField.bottomAnchor, constant: 8),
            purchaseLimitHintLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            purchaseLimitHintLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),

            chequeBlikTitleLabel.topAnchor.constraint(equalTo: purchaseLimitHintLabel.bottomAnchor, constant: 32),
            chequeBlikTitleLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            chequeBlikTitleLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            
            chequeBlikLimitLabel.topAnchor.constraint(equalTo: chequeBlikTitleLabel.bottomAnchor, constant: 16),
            chequeBlikLimitLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            chequeBlikLimitLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            
            chequeBlikLimitValueLabel.topAnchor.constraint(equalTo: chequeBlikLimitLabel.bottomAnchor, constant: 4),
            chequeBlikLimitValueLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            chequeBlikLimitValueLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            
            withdrawLimitAccessoryView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func configureStyling() {
        limitsTitleLabel.textColor = .lisboaGray
        limitsTitleLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 17
        )
        
        withdrawLimitTextField.textField.setRightAccessory(.view(withdrawLimitAccessoryView))
        withdrawLimitTextField.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .floatingTitle,
                    formatter: PLAmountTextFieldFormatter(),
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .decimalPad
                    }
                )
            )
        )
        
        withdrawLimitHintLabel.textColor = .brownGray
        withdrawLimitHintLabel.font = .santander(
            family: .micro,
            type: .light,
            size: 14
        )
        
        purchaseLimitTextField.textField.setRightAccessory(.view(purchaseLimitAccessoryView))
        purchaseLimitTextField.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .floatingTitle,
                    formatter: PLAmountTextFieldFormatter(),
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .decimalPad
                    }
                )
            )
        )
        
        purchaseLimitHintLabel.textColor = .brownGray
        purchaseLimitHintLabel.font = .santander(
            family: .micro,
            type: .light,
            size: 14
        )
        
        chequeBlikTitleLabel.textColor = .lisboaGray
        chequeBlikTitleLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 17
        )
        
        chequeBlikLimitLabel.textColor = .brownGray
        chequeBlikLimitLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        chequeBlikLimitValueLabel.textColor = .lisboaGray
        chequeBlikLimitValueLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 16
        )
    }
}

extension TransactionLimitView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        delegate?.didUpdateLimit()
    }
}
