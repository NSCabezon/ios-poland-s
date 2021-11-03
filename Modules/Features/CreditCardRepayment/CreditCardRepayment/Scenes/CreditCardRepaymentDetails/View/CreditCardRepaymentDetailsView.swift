//
//  CreditCardRepaymentDetailsView.swift
//  CreditCardRepayment
//
//  Created by 186490 on 08/06/2021.
//

import UI
import PLUI
import Commons
import IQKeyboardManagerSwift

private enum Constants {
    static let buttonsHeight: CGFloat = 70
    static let textFieldsHeight: CGFloat = 48.0
    static let textFieldsHeightWithError: CGFloat = 68.0
    
    static let accessoryViewsWidth: CGFloat = 45
    static let contentViewHorizontalSpacing: CGFloat = 17
    
    static let toolbarDistance: CGFloat = 34.0
    static let animationDuration: TimeInterval = 0.2
    
    static let nextButtonHeight: CGFloat = 65
    
    static let scrollViewContentInset = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
    
    static let stackViewSpacing: CGFloat = 25
}

final class CreditCardRepaymentDetailsView: UIView {
    private let headerView = NavigationBarBottomExtendView()
    private let bottomView = BottomView()
    private let editView = NavigationBarEditView()
    private let contentView = PLScrollableStackView()
    private let accountInfoButton = MultilineButton()
    
    private let repaymentTypeInfoButton = MultilineButton()
    private let repaymentAmountView = LisboaTextFieldWithErrorView()
    private var repaymentAmountTextField: LisboaTextField { return repaymentAmountView.textField }
    private let repaymentAmountAccessoryView = AccessoryTextView()
    
    private let dateChooserTextField: LisboaTextfield = LisboaTextfield()

    private var bottomKeyboardAnchorConstraint: NSLayoutConstraint!
    private var repaymentAmountViewHeightConstraint: NSLayoutConstraint!
    
    var didChangeAmount: ((String) -> Void)?
    var didEndEditingDate: ((Date) -> Void)?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpView() {
        backgroundColor = .white
        
        headerView.addSubview(editView)
        addSubview(contentView)
        addSubview(bottomView)
        addSubview(headerView)
        
        contentView.addArrangedSubview(accountInfoButton)
        contentView.addArrangedSubview(repaymentTypeInfoButton)
        contentView.addArrangedSubview(repaymentAmountView)
        contentView.addArrangedSubview(dateChooserTextField)
    }

    private func setUpSubviews() {
        setUpRepaymentAmountTextField()
        setUpDateChooserTextField()
        setUpContentViewSpacing()
    }

    private func setUpLayouts() {
        setupHeaderViewConstraints()
        setupEditHeaderViewConstraints()
        setupContentViewConstraints()
        setupButtonsConstraints()
        
        setUpTextFieldContraints()
        setUpRepaymentAmountAccessoryViewContraints()
        
        setupBottomViewConstraints()
    }
    
    private func setUpRepaymentAmountTextField() {
        // TODO:
        // This formatter should be taken from the common place instead.
        let amountFormatter = PLAmountTextFieldFormatter(maximumIntegerDigits: 5,
                                                         maximumFractionDigits: 2,
                                                         usesGroupingSeparator: false)
        let configuration = LisboaTextField.WritableTextField(
            type: .floatingTitle,
            formatter: amountFormatter,
            disabledActions: [],
            keyboardReturnAction: nil,
            textfieldCustomizationBlock: setUpAmountTextField(_:)
        )
        
        repaymentAmountTextField.setEditingStyle(.writable(configuration: configuration))
        repaymentAmountTextField.setRightAccessory(.view(repaymentAmountAccessoryView))
        repaymentAmountTextField.updatableDelegate = self
    }
    
    private func setUpAmountTextField(_ component: LisboaTextField.CustomizableComponents) {
        component.textField.autocorrectionType = .no
        component.textField.spellCheckingType = .no
        component.textField.keyboardType = .decimalPad
    }
    
    private func setUpDateChooserTextField() {
        dateChooserTextField.configure(
            with: nil,
            title: localized("pl_creditCard_label_repDate"),
            extraInfo: (
                image: UIImage(named: "calendar", in: .module, compatibleWith: nil),
                action: { [weak self] in
                    self?.dateChooserTextField.field.becomeFirstResponder()
                }
            ),
            disabledActions: TextFieldActions.usuallyDisabledActions
        )
        setUpDatePicker(for: dateChooserTextField,
                        date: Date(),
                        minimumDate: Date(),
                        maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date())
        dateChooserTextField.field.addTarget(self, action: #selector(datePickerDidEndEditing), for: .editingDidEnd)
    }
    
    private func setupButtonsConstraints() {
        [accountInfoButton, repaymentTypeInfoButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight)
            ])
        }
    }
    
    private func setUpTextFieldContraints() {
        repaymentAmountViewHeightConstraint = repaymentAmountView.heightAnchor.constraint(equalToConstant: Constants.textFieldsHeight)
        
        NSLayoutConstraint.activate([
            repaymentAmountViewHeightConstraint,
            dateChooserTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldsHeight)
        ])
    }
    
    private func setUpRepaymentAmountAccessoryViewContraints() {
        repaymentAmountAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            repaymentAmountAccessoryView.widthAnchor.constraint(equalToConstant: Constants.accessoryViewsWidth)
        ])
    }
    
    private func setupHeaderViewConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 68.0)
        ])
    }
    
    private func setupEditHeaderViewConstraints() {
        editView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            editView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 17.0),
            editView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            editView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8.0),
            editView.heightAnchor.constraint(equalToConstant: 37.0)
        ])
    }
    
    private func setUpContentViewSpacing() {
        contentView.contentInset = Constants.scrollViewContentInset
        contentView.spacing = Constants.stackViewSpacing
    }
    
    private func setupContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentViewHorizontalSpacing),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentViewHorizontalSpacing),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }

    private func setupBottomViewConstraints() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomKeyboardAnchorConstraint = bottomView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),
            bottomKeyboardAnchorConstraint
        ])
    }
}

extension CreditCardRepaymentDetailsView: CreditCardRepaymentDetailsViewModelSetupProtocol {
    func setupEditHeader(with viewModel: CreditCardRepaymentDetailsEditHeaderViewModel) {
        editView.setup(with: viewModel)
    }
    
    func setupAccountTypeInfo(with viewModel: CreditCardRepaymentDetailsAccountInfoViewModel) {
        accountInfoButton.setup(with: viewModel)
    }

    func setupRepaymentTypeInfo(with viewModel: CreditCardRepaymentDetailsRepaymentTypeInfoViewModel) {
        repaymentTypeInfoButton.setup(with: viewModel)
    }
    
    func setupRepaymentAmount(with viewModel: CreditCardRepaymentDetailsRepaymentAmountViewModel) {
        UIView.performWithoutAnimation {
            didChangeAmount = viewModel.didChange
            repaymentAmountTextField.setup(with: viewModel, actionView: repaymentAmountAccessoryView)
            if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                showError(errorMessage)
            } else {
                hideError()
            }
        }
    }
    
    func setupDateInfo(with viewModel: CreditCardRepaymentDateInfoViewModel) {
        dateChooserTextField.updateData(text: viewModel.date.toString())
        didEndEditingDate = viewModel.didEndEditing
    }
    
    func setupNext(with viewModel: CreditCardRepaymentDetailsNextViewModel) {
        bottomView.setup(with: viewModel)
    }
}

private extension CreditCardRepaymentDetailsView.NavigationBarEditView {
    func setup(with viewModel: CreditCardRepaymentDetailsEditHeaderViewModel) {
        setup(topText: viewModel.title, bottomText: viewModel.description)
        isEditVisible = viewModel.isEditVisible
        onTouchAction = { _ in
            viewModel.tapAction?()
        }
    }
}

private extension CreditCardRepaymentDetailsView.MultilineButton {
    func setup(with viewModel: CreditCardRepaymentDetailsAccountInfoViewModel) {
        setTitle(viewModel.title, description: viewModel.description)
        isEdgesVisible = viewModel.isEdgesVisible
        onTouchAction = { _ in
            viewModel.tapAction?()
        }
    }
    
    func setup(with viewModel: CreditCardRepaymentDetailsRepaymentTypeInfoViewModel) {
        setTitle(viewModel.title, description: viewModel.description)
        isEdgesVisible = viewModel.isEdgesVisible
        onTouchAction = { _ in
            viewModel.tapAction?()
        }
    }
}

private extension LisboaTextField {
    func setup(with viewModel: CreditCardRepaymentDetailsRepaymentAmountViewModel, actionView: CreditCardRepaymentDetailsView.AccessoryTextView) {
        if let initialText = viewModel.initialText {
            setText(initialText)
        }
        
        isUserInteractionEnabled = viewModel.canEdit
        setPlaceholder(viewModel.placeholder)
        actionView.setText(viewModel.currency)
    }
}

private extension CreditCardRepaymentDetailsView.BottomView {
    func setup(with viewModel: CreditCardRepaymentDetailsNextViewModel) {
        onTouchAction = viewModel.tapAction
        isEnabled = viewModel.isEnabled
    }
}

extension CreditCardRepaymentDetailsView {
    
    func configureKeyboard() {
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard  let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue
        bottomKeyboardAnchorConstraint.constant = -keyboardFrame.height + Constants.toolbarDistance
        self.bringSubviewToFront(bottomView)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomKeyboardAnchorConstraint.constant = 0.0
    }
    
    func setUpAmountTextFieldHeight(_ value: CGFloat) {
        repaymentAmountViewHeightConstraint.constant = value
    }
    
    func showError(_ error: String) {
        repaymentAmountView.showError(error)
        setUpAmountTextFieldHeight(Constants.textFieldsHeightWithError)
    }

    func hideError() {
        repaymentAmountView.hideError()
        setUpAmountTextFieldHeight(Constants.textFieldsHeight)
    }
    
}

extension CreditCardRepaymentDetailsView: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        didChangeAmount?(repaymentAmountTextField.text ?? "")
    }
}

extension CreditCardRepaymentDetailsView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        didChangeAmount?(textField.text ?? "")
    }
    
}

private extension CreditCardRepaymentDetailsView {
    func setUpDatePicker(for field: LisboaTextfield, date: Date, minimumDate: Date, maximumDate: Date) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.date = date
        datePicker.locale = Locale(identifier: "pl")
        datePicker.timeZone = TimeZone(abbreviation: "GMT")
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        field.field.inputView = datePicker
    }
    
    @objc func datePickerValueChanged() {
        if let textField = dateChooserTextField.field.inputView as? UIDatePicker {
            dateChooserTextField.field.text = textField.date.toString()
        }
    }
    
    @objc func datePickerDidEndEditing() {
        if let textField = dateChooserTextField.field.inputView as? UIDatePicker {
            didEndEditingDate?(textField.date)
        }
    }
}

private extension Date {
    static let formatter = DateFormatter()

    func toString(format: String = "dd.MM.yyyy") -> String {
        Date.formatter.dateFormat = format
        return Date.formatter.string(from: self)
    }
}
