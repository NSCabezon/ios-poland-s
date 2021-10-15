
import UI
import Commons
import PLUI
import SANLegacyLibrary
import PLCommons

protocol CharityTransferFormViewDelegate: AnyObject {
    func changeAccountTapped()
}

class CharityTransferFormView: UIView {
    
    private let headerLabel = UILabel()
    private let accountSelectorLabel = UILabel()
    private let selectedAccountView = SelectedAccountView()
    private let recipientFieldName = UILabel()
    private let recipientTextField = UneditableField()
    private let accountNumberFieldName = UILabel()
    private let accountNumberTextField = UneditableField()
    private let amountFieldName = UILabel()
    private let amountTextField = LisboaTextField()
    private let currencyAccessoryView = CurrencyAccessoryView()
    private let titleFieldName = UILabel()
    private let titleTextField = UneditableField()
    private let dateFieldName = UILabel()
    private let views: [UIView]
    
    weak var delegate: CharityTransferFormViewDelegate?
    
    override init(frame: CGRect) {
        views = [headerLabel,
                 accountSelectorLabel, selectedAccountView,
                 recipientFieldName, recipientTextField,
                 accountNumberFieldName, accountNumberTextField,
                 amountFieldName, amountTextField,
                 titleFieldName, titleTextField,
                 dateFieldName]
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with accountViewModel: [SelectableAccountViewModel]) {
        selectedAccountView.setViewModel(accountViewModel)
    }
}

private extension CharityTransferFormView {
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        views.forEach { [weak self] view in
            self?.addSubview(view)
        }
    }
    
    func prepareStyles() {
        backgroundColor = .white
        
        headerLabel.text = localized("pl_foundtrans_text_aboutFound")
        headerLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                            font: .santander(family: .micro,
                                                             type: .regular,
                                                             size: 14),
                                            textAlignment: .center))
        headerLabel.numberOfLines = 0
        accountSelectorLabel.text = localized("pl_foundtrans_text_accountTransfter")
        selectedAccountView.setChangeAction { [weak self] in
            self?.delegate?.changeAccountTapped()
        }
        prepareStylesForRecipienField()
        prepareStylesForAccountNumberField()
        prepareStylesForAmountField()
        prepareStylesForTitleField()
        prepareStylesForDateField()
        [accountSelectorLabel, recipientFieldName, accountNumberFieldName, amountFieldName, titleFieldName, dateFieldName].forEach { label in
            label.applyStyle(LabelStylist(textColor: .lisboaGray,
                                          font: .santander(family: .micro,
                                                           type: .regular,
                                                           size: 14)))
        }
    }
    
    func prepareStylesForRecipienField() {
        recipientFieldName.text = localized("pl_foundtrans_text_recipientTransfer")
        recipientTextField.setText("pl_foundtrans_text_RecipFoudSant")
        recipientTextField.setRightAccessoryView(.image(Assets.image(named: "icnUser")))
    }
    
    func prepareStylesForAccountNumberField() {
        accountNumberFieldName.text = localized("pl_foundtrans_text_accountNumb")
        //TODO: need to get account number form microsite - TAP 2014
        accountNumberTextField.setText(localized("53 1090 1056 0000 0001 4750 0104"))
    }
    
    func prepareStylesForAmountField() {
        amountFieldName.text = localized("pl_foundtrans_text_transfAmount")
        let amountFormatter = PLAmountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: amountFormatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: setUpAmountTextField(_:))
        amountTextField.setEditingStyle(.writable(configuration: configuration))
        currencyAccessoryView.setText(CurrencyType.złoty.name)
        amountTextField.setRightAccessory(.view(currencyAccessoryView))
        amountTextField.setPlaceholder(localized("pl_foundtrans_text_transfAmount"))
    }
    
    func prepareStylesForTitleField() {
        titleFieldName.text = localized("pl_foundtrans_text_transfTitle")
        titleTextField.setText("pl_foundtrans_text_titleTransFound")
    }
    
    func prepareStylesForDateField() {
        dateFieldName.text = localized("pl_foundtrans_text_whenToSend")
    }
    
    func setUpAmountTextField(_ component: LisboaTextField.CustomizableComponents) {
        component.textField.autocorrectionType = .no
        component.textField.spellCheckingType = .no
        component.textField.keyboardType = .decimalPad
    }
    
    func setUpLayout() {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            accountSelectorLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            accountSelectorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountSelectorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            selectedAccountView.topAnchor.constraint(equalTo: accountSelectorLabel.bottomAnchor, constant: 8),
            selectedAccountView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            selectedAccountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            recipientFieldName.topAnchor.constraint(equalTo: selectedAccountView.bottomAnchor, constant: 25),
            recipientFieldName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            recipientFieldName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            recipientTextField.topAnchor.constraint(equalTo: recipientFieldName.bottomAnchor, constant: 8),
            recipientTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            recipientTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            recipientTextField.heightAnchor.constraint(equalToConstant: 48),
            
            accountNumberFieldName.topAnchor.constraint(equalTo: recipientTextField.bottomAnchor, constant: 16),
            accountNumberFieldName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountNumberFieldName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            accountNumberTextField.topAnchor.constraint(equalTo: accountNumberFieldName.bottomAnchor, constant: 8),
            accountNumberTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountNumberTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            accountNumberTextField.heightAnchor.constraint(equalToConstant: 48),
            
            amountFieldName.topAnchor.constraint(equalTo: accountNumberTextField.bottomAnchor, constant: 16),
            amountFieldName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            amountFieldName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            amountTextField.topAnchor.constraint(equalTo: amountFieldName.bottomAnchor, constant: 8),
            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            amountTextField.heightAnchor.constraint(equalToConstant: 48),
            currencyAccessoryView.widthAnchor.constraint(equalToConstant: 44),
            
            titleFieldName.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            titleFieldName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleFieldName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            titleTextField.topAnchor.constraint(equalTo: titleFieldName.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),
            
            dateFieldName.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            dateFieldName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            dateFieldName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            dateFieldName.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -16),
        ])
    }
}
