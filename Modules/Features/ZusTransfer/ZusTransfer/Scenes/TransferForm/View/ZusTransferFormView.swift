import UI
import Commons
import PLUI
import SANLegacyLibrary
import PLCommons

protocol ZusTransferFormViewDelegate: AnyObject {
    func changeAccountTapped()
    func didChangeForm()
}

final class ZusTransferFormView: UIView {
    private let accountSelectorLabel = UILabel()
    private let selectedAccountView = SelectedAccountView()
    private let recipientFieldName = UILabel()
    private let recipientTextField = LisboaTextField()
    private let accountNumberFieldName = UILabel()
    private let accountNumberTextField = LisboaTextField()
    private let amountFieldName = UILabel()
    private let amountView = LisboaTextFieldWithErrorView()
    private var amountTextField: LisboaTextField { return amountView.textField }
    private let currencyAccessoryView = CurrencyAccessoryView()
    private let titleFieldName = UILabel()
    private let titleDescriptionLabel = UILabel()
    private let titleTextField = LisboaTextField()
    private let dateFieldName = UILabel()
    private let transferDateSelector: TransferDateSelector
    private let textFieldsMainContainer = UIStackView()
    private let views: [UIView]
    private var selectedDate = Date()
    
    weak var delegate: ZusTransferFormViewDelegate?
    
    init(language: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PLTimeFormat.ddMMyyyyDotted.rawValue
        transferDateSelector = TransferDateSelector(
            language: language,
            dateFormatter: dateFormatter
        )
        views = [accountSelectorLabel, selectedAccountView,
                 textFieldsMainContainer,
                 titleDescriptionLabel, dateFieldName,
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
    
    func getCurrentFormViewModel() -> ZusTransferFormViewModel {
        ZusTransferFormViewModel(
            amount: Decimal(string: amountTextField.text ?? ""),
            date: selectedDate,
            recipientAccountNumberUnformatted: recipientTextField.text?.replace(" ", "") ?? ""
        )
    }
    
    func showInvalidFormMessages(_ messages: InvalidZusTransferFormMessages) {
        if messages.tooLowAmount != nil || messages.tooMuchAmount != nil {
            amountView.showError(messages.tooLowAmount ?? messages.tooMuchAmount)
        } else {
            amountView.hideError()
        }
    }
}

private extension ZusTransferFormView {
    func setUp() {
        addSubviews()
        configureView()
        setUpLayout()
    }
    
    func addSubviews() {
        views.forEach {
            self.addSubview($0)
        }
        [createTextFieldContainer(with: recipientFieldName, textFieldView: recipientTextField),
         createTextFieldContainer(with: accountNumberFieldName, textFieldView: accountNumberTextField),
         createTextFieldContainer(with: amountFieldName, textFieldView: amountView),
         createTextFieldContainer(with: titleFieldName, textFieldView: titleTextField)
        ]
        .forEach {
            textFieldsMainContainer.addArrangedSubview($0)
        }
    }
    
    func configureView() {
        backgroundColor = .white
        accountSelectorLabel.text = localized("#Konto, z którego robisz przelew")
        selectedAccountView.setChangeAction { [weak self] in
            self?.delegate?.changeAccountTapped()
        }
        configureRecipienField()
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
    
    func configureRecipienField() {
        recipientFieldName.text = localized("#Odbiorca")
        recipientTextField.setText("#ZUS")
        recipientTextField.setRightAccessory(.image("icnUser", action: {}))
    }
    
    func configureAccountNumberField() {
        accountNumberFieldName.text = localized("#Numer konta")
    }
    
    func configureAmountField() {
        amountFieldName.text = localized("#Kwota")
        let amountFormatter = PLAmountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: amountFormatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: setUpAmountTextField(_:))
        amountTextField.setEditingStyle(.writable(configuration: configuration))
        currencyAccessoryView.setText(CurrencyType.złoty.name)
        amountTextField.setRightAccessory(.view(currencyAccessoryView))
        amountTextField.setPlaceholder(localized("#Kwota"))
        amountTextField.updatableDelegate = self
    }
    
    func configureTitleField() {
        titleFieldName.text = localized("#Tytuł")
        titleTextField.setText("#Przelew")
    }
    
    func configureTitleDescriptionLabel() {
        titleDescriptionLabel.text = localized("#Nadaj tytuł przelewu, który pozwoli Ci go łatwo zidentyfikować, np. ZUS marzec 2018 Jan Kowalski")
        titleDescriptionLabel.applyStyle(LabelStylist(textColor: .brownishGray,
                                            font: .santander(family: .micro,
                                                             type: .regular,
                                                             size: 14),
                                            textAlignment: .left))
        titleDescriptionLabel.numberOfLines = 0
    }
    
    func configureDateField() {
        dateFieldName.text = localized("#Kiedy mamy wysłać ten przelew?")
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
            textFieldsMainContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textFieldsMainContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            recipientTextField.heightAnchor.constraint(equalToConstant: 48),
            accountNumberTextField.heightAnchor.constraint(equalToConstant: 48),
            currencyAccessoryView.widthAnchor.constraint(equalToConstant: 44),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),

            titleDescriptionLabel.topAnchor.constraint(equalTo: textFieldsMainContainer.bottomAnchor, constant: 8),
            titleDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            dateFieldName.topAnchor.constraint(equalTo: titleDescriptionLabel.bottomAnchor, constant: 16),
            dateFieldName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            dateFieldName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            transferDateSelector.topAnchor.constraint(equalTo: dateFieldName.bottomAnchor, constant: 8),
            transferDateSelector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            transferDateSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            transferDateSelector.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -16),
        ])
    }
    
    private func createTextFieldContainer(with headerView: UIView, textFieldView: UIView) -> UIView {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(textFieldView)
        return stackView
    }
}

extension ZusTransferFormView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        delegate?.didChangeForm()
    }
}

extension ZusTransferFormView: TransferDateSelectorDelegate {
    func didSelectDate(date: Date) {
        selectedDate = date
        delegate?.didChangeForm()
    }
}
