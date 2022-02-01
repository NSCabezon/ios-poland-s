
import UI
import CoreFoundationLib

protocol AnotherDayViewDelegate: AnyObject {
    func didSelectDate()
}

class AnotherDateView: UIView {
    
    private let stackView = UIStackView()
    private let label = UILabel()
    private let dateTextField = LisboaTextField()
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private let language: String
    private let dateFormatter: DateFormatter
    
    weak var delegate: AnotherDayViewDelegate?
    
    private var selectedDate = Date() {
        didSet {
            dateTextField.setText(dateFormatter.string(from: selectedDate))
        }
    }
    
    init(language: String,
         dateFormatter: DateFormatter) {
        self.language = language
        self.dateFormatter = dateFormatter
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSelectedDate() -> Date {
        datePicker.date
    }
}

private extension AnotherDateView {
    
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(dateTextField)
    }
    
    func prepareStyles() {
        stackView.axis = .vertical
        stackView.spacing = 8
        
        label.applyStyle(LabelStylist(textColor: .lisboaGray,
                                      font: .santander(family: .micro,
                                                       type: .regular,
                                                       size: 14),
                                      textAlignment: .left))
        label.text = localized("pl_foundtrans_text_dateTransfer")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" //TODO: change to TimeFormat when this format will be available
        
        let configuration = LisboaTextField.WritableTextField(type: .simple,
                                                              formatter: nil,
                                                              disabledActions: [],
                                                              keyboardReturnAction: nil,
                                                              textfieldCustomizationBlock: setUpAnotherDayTextField(_:))
        dateTextField.setEditingStyle(.writable(configuration: configuration))
        
        dateTextField.setText(dateFormatter.string(from: Date()))
        dateTextField.setRightAccessory(.uiImage(Assets.image(named: "analysisBtnCalendar"), action: {}))
        
        prepareDatePicker()
        prepareDatePickerToolbar()
    }
    
    func prepareDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.date = Date()
        datePicker.locale = Locale(identifier: language)
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(Constants.oneYear)
    }
    
    func prepareDatePickerToolbar() {
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.santanderRed
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: localized("generic_button_accept"), style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: localized("generic_button_cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
    }
    
    func setUpLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            dateTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setUpAnotherDayTextField(_ component: LisboaTextField.CustomizableComponents) {
        component.textField.inputView = datePicker
        component.textField.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        selectedDate = datePicker.date
        dateTextField.resignFirstResponder()
        delegate?.didSelectDate()
    }
    
    @objc func cancelPicker() {
        self.endEditing(true)
        datePicker.date = selectedDate
    }
    
    private enum Constants {
       static let oneYear: Double = 60*60*24*365
    }
}


