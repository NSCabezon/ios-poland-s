import UI
import CoreFoundationLib
import PLUI
import SANLegacyLibrary
import PLCommons

protocol SplitPaymentFormViewDelegate: AnyObject {
    func changeAccountTapped()
    func didChangeForm(with field: TransferFormCurrentActiveField)
    func didTapRecipientButton()
    func scrollToBottom()
}

final class SplitPaymentFormView: UIView {
    private let accountSelectorLabel = UILabel()
    private let selectedAccountView = SelectedAccountView()
    private let recipientFieldName = UILabel()
    private let recipientView = LisboaTextFieldWithErrorView()
    private var recipientTextField: LisboaTextField { return recipientView.textField }
    private let accountNumberFieldName = UILabel()
    private let accountView = LisboaTextFieldWithErrorView()
    private var accountNumberTextField: LisboaTextField { return accountView.textField }
    
    private let nipFieldName = UILabel()
    private let nipView = LisboaTextFieldWithErrorView()
    private var nipTextField: LisboaTextField { return nipView.textField }
    
    private let grossAmountFieldName = UILabel()
    private let grossAmountView = LisboaTextFieldWithErrorView()
    private var grossAmountTextField: LisboaTextField { return grossAmountView.textField }
    private let grossCurrencyAccessoryView = CurrencyAccessoryView()
    
    private let vatAmountFieldName = UILabel()
    private let vatAmountView = LisboaTextFieldWithErrorView()
    private var vatAmountTextField: LisboaTextField { return vatAmountView.textField }
    private let vatCurrencyAccessoryView = CurrencyAccessoryView()
    private let titleFieldName = UILabel()
    private let titleView = LisboaTextFieldWithErrorView()
    private var titleTextField: LisboaTextField { return titleView.textField }
    
    private let invoiceTitleFieldName = UILabel()
    private let invoiceTitleView = LisboaTextFieldWithErrorView()
    private var invoiceTitleTextField: LisboaTextField { return invoiceTitleView.textField }
    
    private let dateFieldName = UILabel()
    private let transferDateSelector: TransferDateSelector
    private let textFieldsMainContainer = UIStackView()
    private let views: [UIView]
    private var selectedDate = Date()
    private var currentActiveField = TransferFormCurrentActiveField.none
    private let recipientTextFieldDelegate = TextFieldDelegate()
    private let accountNumberTextFieldDelegate = TextFieldDelegate()
    private let nipTextFieldDelegate = TextFieldDelegate()
    private let grossAmountTextFieldDelegate = TextFieldDelegate()
    private let vatAmountTextFieldDelegate = TextFieldDelegate()
    private let invoiceTitleTextFieldDelegate = TextFieldDelegate()
    private let titleTextFieldDelegate = TextFieldDelegate()
    private var accountNumberWasEditing = false
    weak var delegate: SplitPaymentFormViewDelegate?

    init(language: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PLTimeFormat.ddMMyyyyDotted.rawValue
        transferDateSelector = TransferDateSelector(
            language: language,
            dateFormatter: dateFormatter
        )
        views = [accountSelectorLabel, selectedAccountView,
                 textFieldsMainContainer,
                 dateFieldName,
                 transferDateSelector]
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with accountViewModel: [SelectableAccountViewModel]) {
        selectedAccountView.setViewModel(accountViewModel)
    }
    
    func getCurrentFormViewModel() -> SplitPaymentFormViewModel {
        SplitPaymentFormViewModel(recipient: recipientTextField.text ?? "",
                                  nip: nipTextField.text ?? "",
                                  grossAmount: Decimal(string: grossAmountTextField.text ?? "") ?? 0,
                                  vatAmount: Decimal(string: vatAmountTextField.text ?? "") ?? 0,
                                  invoiceTitle: invoiceTitleTextField.text ?? "",
                                  title: titleTextField.text ?? "",
                                  date: selectedDate,
                                  recipientAccountNumber: accountNumberTextField.text?.replace(" ", "") ?? "")
    }
    
    func setCurrentActiveFieldType(_ type: TransferFormCurrentActiveField) {
        currentActiveField = type
    }
    
    func showInvalidFormMessages(with data: InvalidSplitPaymentFormData) {
        switch data.currentActiveField {
        case .recipient:
            showError(for: recipientView, with: data.invalidRecieptMessages)
        case .accountNumber(_):
            showError(for: accountView, with: data.invalidAccountMessages)
        case .nip:
            showError(for: nipView, with: data.invalidNipAmountMessages)
        case .grossAmount:
            showError(for: grossAmountView, with: data.invalidGrossAmountMessages)
        case .title:
            showError(for: titleView, with: data.invalidTitleMessages)
        case .vatAmount:
            showError(for: vatAmountView, with: data.invalidVatAmountMessages)
        case .invoiceTitle:
            showError(for: invoiceTitleView, with: data.invalidInvoiceTitleMessages)
        case .date, .none:
            break
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
        nipTextField.setText("")
        grossAmountTextField.setText("")
        vatAmountTextField.setText("")
        invoiceTitleTextField.setText("")
        titleTextField.setText(localized("pl_zusTransfer_text_zusTransfer"))
        selectedDate = Date()
        transferDateSelector.resetToToday()
    }
}

private extension SplitPaymentFormView {
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
         createTextFieldContainer(with: nipFieldName, textFieldView: nipView),
         createTextFieldContainer(with: accountNumberFieldName, textFieldView: accountView),
         createTextFieldContainer(with: grossAmountFieldName, textFieldView: grossAmountView),
         createTextFieldContainer(with: vatAmountFieldName, textFieldView: vatAmountView),
         createTextFieldContainer(with: invoiceTitleFieldName, textFieldView: invoiceTitleView),
         createTextFieldContainer(with: titleFieldName, textFieldView: titleView),
        ]
        .forEach {
            textFieldsMainContainer.addArrangedSubview($0)
        }
    }
    
    func configureView() {
        backgroundColor = .white
        accountSelectorLabel.text = localized("pl_taxTransfer_label_account")
        selectedAccountView.setChangeAction { [weak self] in
            self?.delegate?.changeAccountTapped()
        }
        configureRecipientField()
        configureNipField()
        configureAccountNumberField()
        configureGrossAmountField()
        configureVatAmountField()
        configureInvoiceTitleField()
        configureTitleField()
        configureDateField()
        [accountSelectorLabel,
         recipientFieldName,
         nipFieldName,
         accountNumberFieldName,
         grossAmountFieldName,
         vatAmountFieldName,
         invoiceTitleFieldName,
         titleFieldName,
         dateFieldName]
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
        recipientFieldName.text = localized("pl_split_payment_recipien_transfer_form")
        recipientTextField.setPlaceholder(localized("pl_split_payment_recipien_transfer_form"))
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
        accountNumberFieldName.text = localized("pl_split_payment_account_number_transfer_form")
        let accountFormatter = PLAccountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(
            type: .simple,
            formatter: accountFormatter,
            disabledActions: [],
            keyboardReturnAction: nil,
            textFieldDelegate: nil) { component in
            component.textField.keyboardType = .numberPad
        }
        accountNumberTextField.setPlaceholder(localized("pl_split_payment_account_number_transfer_form"))
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
    
    func configureNipField() {
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 127)
        formatter.setAllowOnlyCharacters(.numbers)
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: formatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil)
        nipFieldName.text = localized("pl_split_payment_nip_transfer_form")
        nipTextField.setPlaceholder(localized("pl_split_payment_nip_transfer_form"))
        nipTextField.setEditingStyle(.writable(configuration: configuration))
        nipTextField.updatableDelegate = self
        nipTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.currentActiveField = .nip
        }
        nipTextFieldDelegate.textFieldDidEndEditing = { [weak self] in
            self?.delegate?.didChangeForm(with: .title)
        }
        formatter.delegate = nipTextFieldDelegate
    }
    
    func configureGrossAmountField() {
        grossAmountFieldName.text = localized("pl_split_payment_gross_ammount_transfer_form")
        let amountFormatter = PLAmountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: amountFormatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: setUpAmountTextField(_:))
        grossAmountTextField.setEditingStyle(.writable(configuration: configuration))
        grossCurrencyAccessoryView.setText(CurrencyType.złoty.name)
        grossAmountTextField.setRightAccessory(.view(grossCurrencyAccessoryView))
        grossAmountTextField.setPlaceholder(localized("pl_split_payment_gross_ammount_transfer_form"))
        grossAmountTextField.updatableDelegate = self
        grossAmountTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.currentActiveField = .grossAmount
        }
        amountFormatter.delegate = grossAmountTextFieldDelegate
    }
    
    func configureVatAmountField() {
        vatAmountFieldName.text = localized("pl_split_payment_vat_ammount_transfer_form")
        let amountFormatter = PLAmountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: amountFormatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: setUpAmountTextField(_:))
        vatAmountTextField.setEditingStyle(.writable(configuration: configuration))
        vatCurrencyAccessoryView.setText(CurrencyType.złoty.name)
        vatAmountTextField.setRightAccessory(.view(vatCurrencyAccessoryView))
        vatAmountTextField.setPlaceholder(localized("pl_split_payment_vat_ammount_transfer_form"))
        vatAmountTextField.updatableDelegate = self
        vatAmountTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.currentActiveField = .vatAmount
        }
        amountFormatter.delegate = vatAmountTextFieldDelegate
    }
    
    func configureInvoiceTitleField() {
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 35)
        formatter.setAllowOnlyCharacters(.operative)
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: formatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil)
        invoiceTitleFieldName.text = localized("#pl_split_payment_invoice_title_transfer_form")
        invoiceTitleTextField.setPlaceholder(localized("#pl_split_payment_invoice_title_transfer_form"))
        invoiceTitleTextField.setEditingStyle(.writable(configuration: configuration))
        invoiceTitleTextField.updatableDelegate = self
        invoiceTitleTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.currentActiveField = .invoiceTitle
        }
        invoiceTitleTextFieldDelegate.textFieldDidEndEditing = { [weak self] in
            self?.delegate?.didChangeForm(with: .invoiceTitle)
        }
        formatter.delegate = invoiceTitleTextFieldDelegate
    }
    
    func configureTitleField() {
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 33)
        formatter.setAllowOnlyCharacters(.operative)
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: formatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil)
        titleFieldName.text = localized("#pl_split_payment_title_transfer_form")
        titleTextField.setText(localized("#pl_split_payment_title_transfer_placeholder_form"))
        titleTextField.setPlaceholder(localized("pl_split_payment_title_transfer_placeholder_form"))
        titleTextField.setEditingStyle(.writable(configuration: configuration))
        titleTextField.updatableDelegate = self
        titleTextFieldDelegate.textFieldDidBeginEditing = { [weak self] in
            guard let self = self else { return }
            self.currentActiveField = .title
        }
        titleTextFieldDelegate.textFieldDidEndEditing = { [weak self] in
            self?.delegate?.didChangeForm(with: .title)
        }
        formatter.delegate = titleTextFieldDelegate
    }

    func configureDateField() {
        dateFieldName.text = localized("pl_split_payment_date_transfer_form")
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
            accountSelectorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            accountSelectorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountSelectorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            selectedAccountView.topAnchor.constraint(equalTo: accountSelectorLabel.bottomAnchor, constant: 8),
            selectedAccountView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            selectedAccountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            textFieldsMainContainer.topAnchor.constraint(equalTo: selectedAccountView.bottomAnchor, constant: 25),
            textFieldsMainContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textFieldsMainContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            recipientTextField.heightAnchor.constraint(equalToConstant: 48),
            accountNumberTextField.heightAnchor.constraint(equalToConstant: 48),
            grossCurrencyAccessoryView.widthAnchor.constraint(equalToConstant: 44),
            vatCurrencyAccessoryView.widthAnchor.constraint(equalToConstant: 44),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),

            dateFieldName.topAnchor.constraint(equalTo: textFieldsMainContainer.bottomAnchor, constant: 16),
            dateFieldName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            dateFieldName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            transferDateSelector.topAnchor.constraint(equalTo: dateFieldName.bottomAnchor, constant: 8),
            transferDateSelector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            transferDateSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            transferDateSelector.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -16),
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

extension SplitPaymentFormView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        if case .accountNumber(_) = currentActiveField {
            accountNumberWasEditing = true
        }
        delegate?.didChangeForm(with: currentActiveField)
    }
}

extension SplitPaymentFormView: TransferDateSelectorDelegate {
    func didSelectDate(date: Date, withOption option: DateTransferOption) {
        selectedDate = date
        currentActiveField = .date
        delegate?.didChangeForm(with: currentActiveField)
        if option == .anotherDay {
            delegate?.scrollToBottom()
        }
    }
}
