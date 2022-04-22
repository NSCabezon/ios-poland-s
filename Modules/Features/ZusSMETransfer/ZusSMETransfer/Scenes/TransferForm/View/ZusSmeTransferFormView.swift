import UI
import CoreFoundationLib
import PLUI
import SANLegacyLibrary
import PLCommons

protocol ZusSmeTransferFormViewDelegate: AnyObject {
    func changeAccountTapped()
    func didChangeForm(with field: TransferFormCurrentActiveField)
    func scrollToBottom()
    func didTapRecipientButton()
}

final class ZusSmeTransferFormView: UIView {
    private let smeHeaderInfoLabel = SmeHeaderInfoView()
    private let vatDetailsView = VatAccountDetailsView()
    private let accountSelectorLabel = UILabel()
    private let selectedAccountView = SelectedAccountView()
    private let recipientFieldName = UILabel()
    private let recipientView = LisboaTextFieldWithErrorView()
    private var recipientTextField: LisboaTextField { return recipientView.textField }
    private let accountNumberFieldName = UILabel()
    private let accountView = LisboaTextFieldWithErrorView()
    private var accountNumberTextField: LisboaTextField { return accountView.textField }
    private let amountFieldName = UILabel()
    private let amountView = LisboaTextFieldWithErrorView()
    private var amountTextField: LisboaTextField { return amountView.textField }
    private let currencyAccessoryView = CurrencyAccessoryView()
    private let titleFieldName = UILabel()
    private let titleDescriptionLabel = UILabel()
    private let titleView = LisboaTextFieldWithErrorView()
    private var titleTextField: LisboaTextField { return titleView.textField }
    private let dateFieldName = UILabel()
    private let transferDateSelector: TransferDateSelector
    private let textFieldsMainContainer = UIStackView()
    private let views: [UIView]
    private var selectedDate = Date()
    private var currentActiveField = TransferFormCurrentActiveField.none
    private let recipientTextFieldDelegate = TextFieldDelegate()
    private let accountNumberTextFieldDelegate = TextFieldDelegate()
    private let titleTextFieldDelegate = TextFieldDelegate()
    private let amountTextFieldDelegate = TextFieldDelegate()
    private var accountNumberWasEditing = false
    weak var delegate: ZusSmeTransferFormViewDelegate?

    init(language: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PLTimeFormat.ddMMyyyyDotted.rawValue
        transferDateSelector = TransferDateSelector(
            language: language,
            dateFormatter: dateFormatter
        )
        views = [
            smeHeaderInfoLabel,
            accountSelectorLabel,
            selectedAccountView,
            vatDetailsView,
            textFieldsMainContainer,
            titleDescriptionLabel,
            dateFieldName,
            transferDateSelector
        ]
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with accountViewModel: [SelectableAccountViewModel]) {
        selectedAccountView.setViewModel(accountViewModel)
    }
    
    func setVatAccountDetails(vatAccountDetails: VATAccountDetails) {
        vatDetailsView.setVatAccountDetails(vatAccountDetails: vatAccountDetails)
    }
    
    func getCurrentFormViewModel() -> ZusSmeTransferFormViewModel {
        ZusSmeTransferFormViewModel(
            recipient: recipientTextField.text ?? "",
            amount: Decimal(string: amountTextField.text ?? "") ?? 0,
            title: titleTextField.text ?? "",
            date: selectedDate,
            recipientAccountNumber: accountNumberTextField.text?.replace(" ", "") ?? ""
        )
    }
    
    func showInvalidFormMessages(with data: InvalidZusSmeTransferFormData) {
        switch data.currentActiveField {
        case .recipient:
            showError(for: recipientView, with: data.invalidRecieptMessages)
        case .accountNumber(_):
            showError(for: accountView, with: data.invalidAccountMessages)
        case .amount:
            showError(for: amountView, with: data.invalidAmountMessages)
        case .title:
            showError(for: titleView, with: data.invalidTitleMessages)
        default: break
        }
    }
    
    func updateRecipient(name: String, accountNumber: String) {
        recipientTextField.setText(name)
        accountNumberTextField.setText(accountNumber)
        let fieldsChanged: [TransferFormCurrentActiveField] = [
            .recipient,
            .accountNumber(controlEvent: .endEditing)
        ]
        fieldsChanged.forEach {
            delegate?.didChangeForm(with: $0)
        }
    }
    
    func clearForm() {
        recipientTextField.setText("")
        accountNumberTextField.setText("")
        amountTextField.setText("")
        titleTextField.setText(localized("pl_zusTransfer_text_zusTransfer"))
        selectedDate = Date()
        transferDateSelector.resetToToday()
    }
}

private extension ZusSmeTransferFormView {
    func setUp() {
        addSubviews()
        configureView()
        setUpLayout()
    }
    
    func addSubviews() {
        views.forEach {
            self.addSubview($0)
        }
        [createTextFieldContainer(with: recipientFieldName, textFieldView: recipientView),
         createTextFieldContainer(with: accountNumberFieldName, textFieldView: accountView),
         createTextFieldContainer(with: amountFieldName, textFieldView: amountView),
         createTextFieldContainer(with: titleFieldName, textFieldView: titleView)
        ]
        .forEach {
            textFieldsMainContainer.addArrangedSubview($0)
        }
    }
    
    func configureView() {
        backgroundColor = .white
        accountSelectorLabel.text = localized("pl_zusTransfer_text_fromAcc")
        selectedAccountView.setChangeAction { [weak self] in
            self?.delegate?.changeAccountTapped()
        }
        configureRecipientField()
        configureAccountNumberField()
        configureAmountField()
        configureTitleField()
        configureTitleDescriptionLabel()
        configureDateField()
        [accountSelectorLabel, recipientFieldName,
         accountNumberFieldName, amountFieldName,
         titleFieldName, dateFieldName]
            .forEach { label in
                label.applyStyle(
                    LabelStylist(
                        textColor: .lisboaGray,
                        font: .santander(family: .micro, type: .regular, size: 14))
                )
            }
        transferDateSelector.delegate = self
        textFieldsMainContainer.spacing = 16
        textFieldsMainContainer.axis = .vertical
    }
    
    func configureRecipientField() {
        recipientFieldName.text = localized("sendMoney_label_recipients")
        recipientTextField.setPlaceholder(localized("pl_zusTransfer_text_zus"))
        recipientTextField.setRightAccessory(
            .uiImage(PLAssets.image(named: "contacts_icon"), action: { [weak self] in
                self?.delegate?.didTapRecipientButton()
            })
        )
        
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 127)
        formatter.setAllowOnlyCharacters(.operative)
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: formatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil)
        recipientTextField.setEditingStyle(.writable(configuration: configuration))
        recipientTextField.updatableDelegate = self
        recipientTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.currentActiveField = .recipient
        }
        formatter.delegate = recipientTextFieldDelegate
    }
    
    func configureAccountNumberField() {
        accountNumberFieldName.text = localized("transaction_label_recipientAccount")
        let accountFormatter = PLAccountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(
            type: .simple,
            formatter: accountFormatter,
            disabledActions: [],
            keyboardReturnAction: nil,
            textFieldDelegate: nil) { component in
            component.textField.keyboardType = .numberPad
        }
        accountNumberTextField.setPlaceholder(localized("transaction_label_recipientAccount"))
        accountNumberTextField.setEditingStyle(.writable(configuration: configuration))
        accountNumberTextField.updatableDelegate = self
        accountNumberTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.currentActiveField = .accountNumber(controlEvent: .beginEditing)
        }
        accountNumberTextFieldDelegate.textFieldDidEndEditing = { [weak self] in
            guard let self = self, self.accountNumberWasEditing else { return }
            self.delegate?.didChangeForm(with: .accountNumber(controlEvent: .endEditing))
        }
        accountFormatter.delegate = accountNumberTextFieldDelegate
    }
    
    func configureAmountField() {
        amountFieldName.text = localized("sendMoney_label_amount")
        let amountFormatter = PLAmountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: amountFormatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: setUpAmountTextField(_:))
        amountTextField.setEditingStyle(.writable(configuration: configuration))
        currencyAccessoryView.setText(CurrencyType.złoty.name)
        amountTextField.setRightAccessory(.view(currencyAccessoryView))
        amountTextField.setPlaceholder(localized("sendMoney_label_amount"))
        amountTextField.updatableDelegate = self
        amountTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.currentActiveField = .amount
        }
        amountFormatter.delegate = amountTextFieldDelegate
    }
    
    func configureTitleField() {
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 127)
        formatter.setAllowOnlyCharacters(.operative)
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: formatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil)
        titleFieldName.text = localized("sendMoney_label_description")
        titleTextField.setText(localized("pl_zusTransfer_text_zusTransfer"))
        titleTextField.setPlaceholder(localized("pl_zusTransfer_text_zusTransfer"))
        titleTextField.setEditingStyle(.writable(configuration: configuration))
        titleTextField.updatableDelegate = self
        titleTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.titleTextField.setText(nil)
            self.currentActiveField = .title
        }
        titleTextFieldDelegate.textFieldDidEndEditing = { [weak self] in
            self?.delegate?.didChangeForm(with: .title)
        }
        formatter.delegate = titleTextFieldDelegate
    }

    func configureTitleDescriptionLabel() {
        titleDescriptionLabel.text = localized("pl_zusTransfer_text_nameTransferHint")
        titleDescriptionLabel.applyStyle(LabelStylist(textColor: .brownishGray,
                                            font: .santander(family: .micro,
                                                             type: .regular,
                                                             size: 14),
                                            textAlignment: .left))
        titleDescriptionLabel.numberOfLines = 0
    }
    
    func configureDateField() {
        dateFieldName.text = localized("transfer_label_periodicity")
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
            smeHeaderInfoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            smeHeaderInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            smeHeaderInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            accountSelectorLabel.topAnchor.constraint(equalTo: smeHeaderInfoLabel.bottomAnchor, constant: 25),
            accountSelectorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountSelectorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            selectedAccountView.topAnchor.constraint(equalTo: accountSelectorLabel.bottomAnchor, constant: 8),
            selectedAccountView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            selectedAccountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            vatDetailsView.topAnchor.constraint(equalTo: selectedAccountView.bottomAnchor, constant: 16),
            vatDetailsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            vatDetailsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            textFieldsMainContainer.topAnchor.constraint(equalTo: vatDetailsView.bottomAnchor, constant: 25),
            textFieldsMainContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textFieldsMainContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            recipientTextField.heightAnchor.constraint(equalToConstant: 48),
            accountNumberTextField.heightAnchor.constraint(equalToConstant: 48),
            currencyAccessoryView.widthAnchor.constraint(equalToConstant: 44),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),

            titleDescriptionLabel.topAnchor.constraint(equalTo: textFieldsMainContainer.bottomAnchor, constant: 8),
            titleDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            titleDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            
            dateFieldName.topAnchor.constraint(equalTo: titleDescriptionLabel.bottomAnchor, constant: 16),
            dateFieldName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            dateFieldName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            transferDateSelector.topAnchor.constraint(equalTo: dateFieldName.bottomAnchor, constant: 8),
            transferDateSelector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transferDateSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            transferDateSelector.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
    
    func createTextFieldContainer(with headerView: UIView, textFieldView: UIView) -> UIView {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(textFieldView)
        return stackView
    }
    
    func showError(
        for view: LisboaTextFieldWithErrorView,
        with message: String?
    ) {
        if let message = message {
            view.showError(message)
            return
        }
        view.hideError()
    }
}

extension ZusSmeTransferFormView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        if case .accountNumber(_) = currentActiveField {
            accountNumberWasEditing = true
        }
        delegate?.didChangeForm(with: currentActiveField)
    }
}

extension ZusSmeTransferFormView: TransferDateSelectorDelegate {
    func didSelectDate(date: Date, withOption option: DateTransferOption) {
        selectedDate = date
        currentActiveField = .date
        delegate?.didChangeForm(with: currentActiveField)
        if option == .anotherDay {
            delegate?.scrollToBottom()
        }
    }
}
