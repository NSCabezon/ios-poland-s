//
//  PLAuthorizationViewController.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 25/10/21.
//

import UIKit
import UI
import UIOneComponents
import Models
import Commons
import PLCommons

protocol PLAuthorizationView: AnyObject {
    func addRemainingTimeView(_ viewModel: RemainingTimeViewModel)
    func addInputBiometricsView(_ viewModel: InputBiometricsViewModel)
    func addInputSignatureView()
    func showGenericError(_ viewModel: BottomSheetErrorViewModel)
    func setContinueButton(_ isEnabled: Bool)
}

final class PLAuthorizationViewController: UIViewController {
    
    @IBOutlet private weak var floattingButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var continueFloatingButton: FloatingButton!
    @IBOutlet private weak var cancelFloatingButton: FloatingButton!
    @IBOutlet private weak var floatingButtonsConstraint: NSLayoutConstraint!
    
    let presenter: PLAuthorizationPresenterProtocol
    private lazy var remainingTimeView: RemainingTimeView = {
        let view = RemainingTimeView()
        view.delegate = self
        return view
    }()
    private lazy var inputSignatureView: InputSignatureView = {
        let view = InputSignatureView()
        view.delegate = self
        return view
    }()
    private lazy var inputBiometricsView = InputBiometricsView()
    private struct Constants {
        static let floattingButtonBottom: CGFloat = 24
        static let floattingButtonBottomKeyboard: CGFloat = -10
    }
    
    init(presenter: PLAuthorizationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "PLAuthorizationViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        self.configureTap()
        self.configureKeyboardListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.configureContinueFloatingButton()
        self.configureCancelFloatingButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction private func didTapOnContinue(_ sender: Any) {
        guard self.continueFloatingButton.isEnabled else { return }
        self.presenter.didSelectContinue()
    }
    @IBAction func didTapOnCancel(_ sender: Any) {
        guard self.cancelFloatingButton.isEnabled else { return }
        view.endEditing(true)
        self.presenter.didSelectBack()
    }
}

extension PLAuthorizationViewController: PLAuthorizationView {
    func setContinueButton(_ isEnabled: Bool) {
        self.continueFloatingButton.isEnabled = isEnabled
    }
    
    func addRemainingTimeView(_ viewModel: RemainingTimeViewModel) {
        self.remainingTimeView.setViewModel(viewModel)
        self.stackView.addArrangedSubview(self.remainingTimeView)
    }
    
    func addInputBiometricsView(_ viewModel: InputBiometricsViewModel) {
        self.inputBiometricsView.delegate = self
        self.inputBiometricsView.setViewModel(viewModel)
        self.stackView.addArrangedSubview(self.inputBiometricsView)
    }
    
    func addInputSignatureView() {
        self.inputSignatureView.delegate = self
        self.stackView.addArrangedSubview(self.inputSignatureView)
    }
    
    func showGenericError(_ viewModel: BottomSheetErrorViewModel) {
        let bottomSheet = BottomSheet()
        let view = self.setGenericErrorView(viewModel)
        let type: SizablePresentationType = .custom(isPan: false)
        bottomSheet.show(in: self, type: type, view: view)
    }
}

extension PLAuthorizationViewController: RemainingTimeDelegate {
    func didTimerEnd() {
        self.presenter.didTimerEnd()
    }
}

private extension PLAuthorizationViewController {
    func setupNavigationBar() {
        OneNavigationBarBuilder(.whiteWithRedComponents)
            .setTitle(withKey: "toolbar_title_mobileAuthorization")
            .setLeftAction(.back, customAction: self.presenter.didSelectBack)
            .setRightAction(.help, action: {
                Toast.show(localized("generic_alert_notAvailableOperation"))
            })
            .setRightAction(.close, action: self.presenter.didSelectClose)
            .build(on: self)
    }
    
    func configureContinueFloatingButton() {
        self.continueFloatingButton.configureWith(
            type: .primary,
            size: .medium(
                FloatingButton.ButtonSize.MediumButtonConfig(title: localized("generic_button_confirm"),
                                                            icons: .none, fullWidth: true)),
            status: .ready)
        self.continueFloatingButton.isEnabled = false
    }
    
    func configureCancelFloatingButton() {
        self.cancelFloatingButton.configureWith(
            type: .secondary,
            size: .medium(
                FloatingButton.ButtonSize.MediumButtonConfig(title: localized("generic_link_cancel"),
                                                             icons: .none, fullWidth: true)),
            status: .ready)
        self.cancelFloatingButton.isEnabled = true
    }
    
    func configureKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardHeight = keyboardSize?.cgRectValue.height
        self.floattingButtonConstraint.constant = keyboardHeight ?? 0 - Constants.floattingButtonBottomKeyboard
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.floattingButtonConstraint.constant = Constants.floattingButtonBottom
    }
    
    func configureTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    func setGenericErrorView(_ viewModel: BottomSheetErrorViewModel) -> BottomSheetErrorView {
        let view = BottomSheetErrorView()
        view.setViewModel(viewModel)
        view.delegate = self
        return view
    }
    
    func setAccessibilityIdentifiers() {
        self.cancelFloatingButton.accessibilityIdentifier = AccessibilityAuthorization.floatingBtnCancel
        self.continueFloatingButton.accessibilityIdentifier = AccessibilityAuthorization.floatingBtnContinue
    }
}

extension PLAuthorizationViewController: InputSignatureViewDelegate {
    func didPinChange(pin: String, isPinComplete: Bool) {
        self.presenter.didPinChange(pin: pin, isPinComplete: isPinComplete)
    }
}

extension PLAuthorizationViewController: InputBiometricsDelegate {
    func didTapBiometry() {
        self.presenter.didTapBiometry()
    }
}

extension PLAuthorizationViewController: BottomSheetErrorDelegate {
    func didTapCancelError() {
        print("Tapped left button")
        self.navigationController?.dismiss(animated: true)
    }
    
    func didTapAcceptError() {
        self.navigationController?.dismiss(animated: true)
        self.presenter.didSelectBack()
    }
}
