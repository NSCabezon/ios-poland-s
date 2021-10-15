import UIKit
import UI
import PLUI
import Commons

protocol TransactionLimitViewDelegate: AnyObject {
    func didUpdateLimit()
}

final class TransactionLimitView: UIView {
    private let limitsTitleLabel = UILabel()
    private let withdrawLimitTextField = LisboaTextField()
    private let withdrawLimitAccessoryView = CurrencyLabel()
    private let withdrawLimitHintLabel = UILabel()
    private let purchaseLimitTextField = LisboaTextField()
    private let purchaseLimitAccessoryView = CurrencyLabel()
    private let purchaseLimitHintLabel = UILabel()
    private let chequqBlikTitleLabel = UILabel()
    private let chequqBlikLimitLabel = UILabel()
    private let chequqBlikLimitValueLabel = UILabel()
    public weak var delegate: TransactionLimitViewDelegate?
    
    public var withdrawLimit: String? {
        withdrawLimitTextField.fieldValue
    }
    
    public var purchaseLimit: String? {
        purchaseLimitTextField.fieldValue
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
        chequqBlikLimitValueLabel.text = viewModel.chequqBlikLimitValue
        withdrawLimitAccessoryView.setText(viewModel.limitCurrency)
        purchaseLimitAccessoryView.setText(viewModel.limitCurrency)
        withdrawLimitHintLabel.text = viewModel.withdrawLimitText
        purchaseLimitHintLabel.text = viewModel.purchaseLimitText
        purchaseLimitTextField.setText(viewModel.purchaseLimitValue)
        withdrawLimitTextField.setText(viewModel.withdrawLimitValue)
    }
}

private extension TransactionLimitView {
    
    func configureContent() {
        limitsTitleLabel.text = localized("pl_blik_text_limitDaily")
        withdrawLimitTextField.setPlaceholder(localized("pl_blik_label_limitCash"))
        purchaseLimitTextField.setPlaceholder(localized("pl_blik_label_limitStores"))
        chequqBlikTitleLabel.text = localized("pl_blik_text_chequeLimit")
        chequqBlikLimitLabel.text = localized("pl_blik_text_oneChequeLimit")
    }
    
    func configureDelegates() {
        withdrawLimitTextField.updatableDelegate = self
        purchaseLimitTextField.updatableDelegate = self
    }
    
    func configureSubviews() {
        addSubview(limitsTitleLabel)
        addSubview(withdrawLimitTextField)
        addSubview(withdrawLimitHintLabel)
        addSubview(purchaseLimitTextField)
        addSubview(purchaseLimitHintLabel)
        
        addSubview(chequqBlikTitleLabel)
        addSubview(chequqBlikLimitLabel)
        addSubview(chequqBlikLimitValueLabel)
        
        limitsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        withdrawLimitTextField.translatesAutoresizingMaskIntoConstraints = false
        withdrawLimitHintLabel.translatesAutoresizingMaskIntoConstraints = false
        purchaseLimitTextField.translatesAutoresizingMaskIntoConstraints = false
        purchaseLimitHintLabel.translatesAutoresizingMaskIntoConstraints = false
        chequqBlikTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        chequqBlikLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        chequqBlikLimitValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            limitsTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            limitsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            limitsTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            withdrawLimitTextField.topAnchor.constraint(equalTo: limitsTitleLabel.bottomAnchor, constant: 16),
            withdrawLimitTextField.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            withdrawLimitTextField.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            withdrawLimitTextField.heightAnchor.constraint(equalToConstant: 48),
            
            withdrawLimitHintLabel.topAnchor.constraint(equalTo: withdrawLimitTextField.bottomAnchor, constant: 8),
            withdrawLimitHintLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            withdrawLimitHintLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),

            purchaseLimitTextField.topAnchor.constraint(equalTo: withdrawLimitHintLabel.bottomAnchor, constant: 16),
            purchaseLimitTextField.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            purchaseLimitTextField.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            purchaseLimitTextField.heightAnchor.constraint(equalToConstant: 48),
            
            purchaseLimitHintLabel.topAnchor.constraint(equalTo: purchaseLimitTextField.bottomAnchor, constant: 8),
            purchaseLimitHintLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            purchaseLimitHintLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),

            chequqBlikTitleLabel.topAnchor.constraint(equalTo: purchaseLimitHintLabel.bottomAnchor, constant: 32),
            chequqBlikTitleLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            chequqBlikTitleLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            
            chequqBlikLimitLabel.topAnchor.constraint(equalTo: chequqBlikTitleLabel.bottomAnchor, constant: 16),
            chequqBlikLimitLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            chequqBlikLimitLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            
            chequqBlikLimitValueLabel.topAnchor.constraint(equalTo: chequqBlikLimitLabel.bottomAnchor, constant: 4),
            chequqBlikLimitValueLabel.leadingAnchor.constraint(equalTo: limitsTitleLabel.leadingAnchor),
            chequqBlikLimitValueLabel.trailingAnchor.constraint(equalTo: limitsTitleLabel.trailingAnchor),
            
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
        
        withdrawLimitTextField.setRightAccessory(.view(withdrawLimitAccessoryView))
        withdrawLimitTextField.setEditingStyle(
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
        
        purchaseLimitTextField.setRightAccessory(.view(purchaseLimitAccessoryView))
        purchaseLimitTextField.setEditingStyle(
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
        
        chequqBlikTitleLabel.textColor = .lisboaGray
        chequqBlikTitleLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 17
        )
        
        chequqBlikLimitLabel.textColor = .brownGray
        chequqBlikLimitLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        chequqBlikLimitValueLabel.textColor = .lisboaGray
        chequqBlikLimitValueLabel.font = .santander(
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
