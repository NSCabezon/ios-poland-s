import UI
import PLUI
import Commons
import PLCommons
import SANLegacyLibrary
import IQKeyboardManagerSwift
import Models

protocol MobileTransferFormViewProtocol: AnyObject {
    func didChangeForm(phoneNumberStartedEdited: Bool)
    func showContacts()
}

final class MobileTransferFormView: UIView {
    
    weak var delegate: MobileTransferFormViewProtocol?
    
    private let stackView = UIStackView()
    private let recipientView = LisboaTextField()
    private let recipientAccessoryView = RecipientAccessoryView()
    private let phoneNumberView = LisboaTextFieldWithErrorView()
    private var phoneNumberTextField: LisboaTextField { return phoneNumberView.textField }
    private let transferAmountView = LisboaTextFieldWithErrorView()
    private var transferAmountTextField: LisboaTextField { return transferAmountView.textField }
    private let transferAmountAccessoryView = CurrencyAccessoryView()
    private let titleView = LisboaTextField()
    private let dateView = LisboaTextField()
    private var phoneNumberDidStartedEdited = false
    private var errorMessages: InvalidMobileTransferFormMessages?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCurrentForm() -> MobileTransferForm {
        var amount: Decimal?
        if let amountText = transferAmountTextField.text, !amountText.isEmpty {
            amount = Decimal(string: amountText)
        }
        let phoneNumber = phoneNumberTextField.text?.replacingOccurrences(of: " ", with: "")
        return MobileTransferForm(recipent: recipientView.text,
                                  phoneNumber: phoneNumber,
                                  amount: amount,
                                  title: titleView.text,
                                  date: Date())
    }
    
    func showInvalidFormMessages(_ messages: InvalidMobileTransferFormMessages) {
        errorMessages = messages
        if messages.tooShortPhoneNumberMessage == nil {
            phoneNumberView.hideError()
        } else {
            phoneNumberView.showError(messages.tooShortPhoneNumberMessage)
        }
        
        if messages.tooLowAmount != nil || messages.tooMuchAmount != nil {
            transferAmountView.showError(messages.tooLowAmount ?? messages.tooMuchAmount)
        } else {
            transferAmountView.hideError()
        }
    }
    
    func fillWith(contact: Contact?) {
        if let contact = contact {
            let formatter = PLPhoneNumberTextFieldFormatter()
            phoneNumberTextField.setText(formatter.formatStrnig(numberInString: contact.phoneNumber))
            if contact.fullName.isEmpty {
                recipientView.setText(formatter.formatStrnig(numberInString: contact.phoneNumber))
            } else {
                recipientView.setText(contact.fullName)
            }
        } else {
            recipientView.setText("")
            phoneNumberTextField.setText("")
        }
    }
    
}

private extension MobileTransferFormView {
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(recipientView)
        stackView.addArrangedSubview(phoneNumberView)
        stackView.addArrangedSubview(transferAmountView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(dateView)
    }
    
    func prepareStyles() {
        backgroundColor = .white
        setUpRecipientView()
        setUpPhoneNumberView()
        setUpTransferAmountTextField()
        setUpTitleView()
        setUpDateTextField()
    }
    
    func setUpRecipientView() {
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 127)
        formatter.setAllowOnlyCharacters(CharacterSet(charactersIn: localized("digits_operative") + "żŻźŹćĆńŃłŁśŚóÓ"))
        recipientView.setPlaceholder(localized("pl_blik_text_recipientTransfer"))
        recipientView.setEditingStyle(.writable(configuration: .init(type: .floatingTitle,
                                                                     formatter: formatter,
                                                                     disabledActions: [],
                                                                     keyboardReturnAction: nil,
                                                                     textFieldDelegate: nil,
                                                                     textfieldCustomizationBlock: nil)))
        recipientView.setRightAccessory(.actionView(recipientAccessoryView, action: { [weak self] in
            self?.delegate?.showContacts()
        }))
        recipientView.updatableDelegate = self
    }
    
    func setUpPhoneNumberView() {
        let formatter = PLPhoneNumberTextFieldFormatter()
        phoneNumberTextField.setPlaceholder(localized("pl_blik_text_phoneTransfer"))
        phoneNumberTextField.setEditingStyle(.writable(configuration: .init(type: .floatingTitle,
                                                                       formatter: formatter,
                                                                       disabledActions: [],
                                                                       keyboardReturnAction: nil,
                                                                       textFieldDelegate: nil,
                                                                       textfieldCustomizationBlock: setUpPhoneNumberTextField(_:))))
        phoneNumberTextField.updatableDelegate = self
    }
    
    func setUpTitleView() {
        titleView.setPlaceholder(localized("pl_blik_label_titleTransfer"))
        titleView.setText(localized("pl_blik_text_title_phoneTransferDeflt"))
        let formatter = UIFormattedCustomTextField()
        formatter.setMaxLength(maxLength: 140)
        formatter.setAllowOnlyCharacters(CharacterSet(charactersIn: localized("digits_operative") + "żŻźŹćĆńŃłŁśŚóÓ "))
        titleView.setEditingStyle(.writable(configuration: .init(type: .floatingTitle,
                                                                 formatter: formatter,
                                                                 disabledActions: [],
                                                                 keyboardReturnAction: nil,
                                                                 textFieldDelegate: self,
                                                                 textfieldCustomizationBlock: nil)))
        titleView.updatableDelegate = self
    }
    
    func setUpDateTextField() {
        dateView.setPlaceholder(localized("pl_blik_label_dateTransfer"))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PLTimeFormat.ddMMyyyyDotted.rawValue
        dateView.setText(dateFormatter.string(from: Date()))
        let formatter = UIFormattedCustomTextField()
        dateView.setEditingStyle(.writable(configuration: .init(type: .floatingTitle,
                                                                formatter: formatter,
                                                                disabledActions: [],
                                                                keyboardReturnAction: nil,
                                                                textFieldDelegate: nil,
                                                                textfieldCustomizationBlock: nil)))
        var style = LisboaTextFieldStyle.default
        style.containerViewBackgroundColor = .lightSanGray
        style.containerViewBorderColor = UIColor.lightSanGray.cgColor
        style.titleLabelFont = .santander(family: .micro, type: .regular, size: 12)
        style.titleLabelTextColor = .brownishGray
        style.fieldTextColor = .brownishGray
        style.verticalSeparatorBackgroundColor = .brownGray
        style.extraInfoHorizontalSeparatorBackgroundColor = .brownGray
        dateView.setStyle(style)
        dateView.setRightAccessory(.uiImage(Images.MobileTransfer.calendar, action: {}))
        dateView.isUserInteractionEnabled = false
    }
    
    func setUpTransferAmountTextField() {
        let amountFormatter = PLAmountTextFieldFormatter()
        let configuration = LisboaTextField.WritableTextField(type: .floatingTitle,
                                                              formatter: amountFormatter,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: setUpAmountTextField(_:))
        transferAmountTextField.setEditingStyle(.writable(configuration: configuration))
        transferAmountAccessoryView.setText(CurrencyType.złoty.name)
        transferAmountTextField.setRightAccessory(.view(transferAmountAccessoryView))
        transferAmountTextField.updatableDelegate = self
        transferAmountTextField.setPlaceholder(localized("pl_blik_text_amountTransfer"))
    }
    
    func setUpPhoneNumberTextField(_ component: LisboaTextField.CustomizableComponents) {
        component.textField.autocorrectionType = .no
        component.textField.spellCheckingType = .no
        component.textField.keyboardType = .numberPad
    }
    
    func setUpAmountTextField(_ component: LisboaTextField.CustomizableComponents) {
        component.textField.autocorrectionType = .no
        component.textField.spellCheckingType = .no
        component.textField.keyboardType = .decimalPad
    }
    
    func setUpLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Const.Anchor.stackView.top),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.Anchor.stackView.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Const.Anchor.stackView.right),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
            
            transferAmountView.heightAnchor.constraint(greaterThanOrEqualToConstant: Const.Size.formField.height),
            transferAmountAccessoryView.widthAnchor.constraint(equalToConstant: Const.Size.accessoryView.width),
            recipientView.heightAnchor.constraint(equalToConstant: Const.Size.formField.height),
            recipientAccessoryView.widthAnchor.constraint(equalToConstant: Const.Size.contactsAccessoryView.width),
            phoneNumberView.heightAnchor.constraint(greaterThanOrEqualToConstant: Const.Size.formField.height),
            titleView.heightAnchor.constraint(equalToConstant: Const.Size.formField.height),
            dateView.heightAnchor.constraint(equalToConstant: Const.Size.formField.height)
        ])
    }
    
}

extension MobileTransferFormView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        //This reset ErrorAppearance is needed because validation is delayed by 1 second and sometimes it causes a delay in the textfield fill
        if let errorMessages = errorMessages {
            errorMessages.tooLowAmount != nil || errorMessages.tooMuchAmount != nil ? transferAmountTextField.setErrorAppearance() : transferAmountTextField.clearErrorAppearance()
            errorMessages.tooShortPhoneNumberMessage != nil ? phoneNumberTextField.setErrorAppearance() : phoneNumberTextField.clearErrorAppearance()
        } else {
            transferAmountTextField.clearErrorAppearance()
            phoneNumberTextField.clearErrorAppearance()
        }
        if !phoneNumberDidStartedEdited {
            phoneNumberDidStartedEdited = !(phoneNumberTextField.text?.isEmpty ?? true)
        }
        delegate?.didChangeForm(phoneNumberStartedEdited: phoneNumberDidStartedEdited)
    }
}

extension MobileTransferFormView: FloatingTitleLisboaTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleView.text?.isEmpty ?? false {
            titleView.setText(localized("pl_blik_text_title_phoneTransferDeflt"))
        }
    }
    
    
}

extension MobileTransferFormView {
    struct Const {
        struct Anchor {
            static let stackView: UIEdgeInsets = .init(top: 17, left: 24, bottom: .zero, right: -24)
        }
        
        struct Size {
            static let formField: CGSize = .init(width: .zero, height: 48)
            static let accessoryView: CGSize = .init(width: 44, height: .zero)
            static let contactsAccessoryView: CGSize = .init(width: 55, height: .zero)
        }
    }
}
