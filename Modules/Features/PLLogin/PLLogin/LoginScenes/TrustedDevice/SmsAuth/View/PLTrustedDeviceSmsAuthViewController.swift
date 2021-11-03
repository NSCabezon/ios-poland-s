//
//  PLTrustedDeviceSmsAuthViewController.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 11/8/21.
//

import UI
import PLUI
import Commons
import PLCommons
import Foundation

protocol PLTrustedDeviceSmsAuthViewProtocol: PLGenericErrorPresentableCapable {
    func showAuthErrorDialog()
}

final class PLTrustedDeviceSmsAuthViewController: UIViewController {
    private let presenter: PLTrustedDeviceSmsAuthPresenterProtocol
    let dependenciesResolver: DependenciesResolver
    private lazy var smsInputCodeView: PLUIInputCodeView = PLUIInputCodeView(keyboardType: .numberPad,
                                                                                        delegate: self,
                                                                                        facade: PLUIInputCodeSMSFacade(facadeStyle: .whiteBackground),
                                                                                        elementSize: Constants.smsBoxSize,
                                                                                        requestedPositions: .all,
                                                                                        charactersSet: Constants.smsCharacterSet)
    private enum Constants {
        static let smsBoxSize = Screen.isScreenSizeBiggerThanIphone5() ? CGSize(width: 39.0, height: 56.0) : CGSize(width: 34, height: 49)
        static let smsCharacterSet: CharacterSet = .decimalDigits
        static let minimumPositionsFulfilled = 8
        static let minimunBottomMargin: CGFloat = 80.0
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var smsCodeContainerView: UIView!
    @IBOutlet weak var sceneTitle: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var closeSceneButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLTrustedDeviceSmsAuthPresenterProtocol) {
        self.presenter = presenter
        self.dependenciesResolver = dependenciesResolver
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObserver()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }
}

extension PLTrustedDeviceSmsAuthViewController: PLTrustedDeviceSmsAuthViewProtocol {
    func showAuthErrorDialog() {
        self.presentError((titleKey: "pl_onboarding_alert_authFailedTitle",
                           descriptionKey: "pl_onboarding_alert_authFailedText")) { [weak self] in
            self?.presenter.goBack()
        }
    }
}

private extension PLTrustedDeviceSmsAuthViewController {
    func setupViews() {
        lockImage.image = PLAssets.image(named: "threeDigitsRedLockIcon")
        configureLabels()
        configureButtons()
        configureSMSAuthView()
    }
    
    func configureLabels() {
        sceneTitle.font = .santander(family: .text, type: .bold, size: 16)
        sceneTitle.textColor = UIColor.Legacy.sanRed // TODO: Review this color code
        sceneTitle.configureText(withKey: "pl_onboarding_title_smsCode", andConfiguration: nil)
        descriptionLabel.font = .santander(family: .text, type: .light, size: 16)
        descriptionLabel.textColor = UIColor.Legacy.lisboaGrayNew
        descriptionLabel.configureText(withKey: "pl_onboarding_text_smsCodeExpl", andConfiguration: nil)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        titleLabel.font = .santander(family: .micro, type: .bold, size: 14)
        titleLabel.textColor = UIColor.Legacy.lisboaGrayNew
        titleLabel.configureText(withKey: "pl_onboarding_text_smsCode", andConfiguration: nil)
    }
    
    func configureButtons() {
        closeSceneButton.isEnabled = true
        closeSceneButton.setImage(Assets.image(named: "icnClose"), for: .normal)
        closeSceneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonDidPressed)))
        
        continueButton.set(localizedStylableText: localized("generic_button_continue"), state: .normal)
        continueButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        continueButton.backgroundColor = UIColor.santanderRed
        continueButton.layer.cornerRadius = (continueButton?.frame.height ?? 0.0) / 2.0
        continueButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 18.0)
        continueButton.backgroundColor = UIColor.lightSanGray
        continueButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueButtonDidPressed)))
    }
    
    func configureSMSAuthView() {
        smsCodeContainerView.addSubview(self.smsInputCodeView)
        NSLayoutConstraint.activate([
            smsInputCodeView.heightAnchor.constraint(equalToConstant: smsCodeContainerView.frame.size.height),
            smsInputCodeView.centerXAnchor.constraint(equalTo: smsCodeContainerView.centerXAnchor),
            smsInputCodeView.topAnchor.constraint(equalTo: smsCodeContainerView.topAnchor),
            smsInputCodeView.bottomAnchor.constraint(equalTo: smsCodeContainerView.bottomAnchor)
        ])
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        self.bottomConstraint.constant = keyboardFrameValue.cgRectValue.height + Constants.minimunBottomMargin
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = Constants.minimunBottomMargin
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: Button actions
    @objc func continueButtonDidPressed() {
        guard let smsCode = self.smsInputCodeView.fulfilledText() else {
            return
        }
        self.presenter.registerConfirm(smsCode: smsCode)
    }
    
    @objc func closeButtonDidPressed() {
        self.presenter.closeButtonDidPressed()
        PLLoginCommonDialogs.presentCloseDialog(on: self, onCancel: {
        }, onAccept: { [weak self] in
            self?.presenter.goBack()
        })
    }
}

extension PLTrustedDeviceSmsAuthViewController: PLUIInputCodeViewDelegate {
    func codeView(_ view: PLUIInputCodeView, didChange string: String, for position: NSInteger) {
        if view.isFulfilled() {
            self.continueButton.isEnabled = true
            self.continueButton.backgroundColor = UIColor.santanderRed
        } else {
            self.continueButton.isEnabled = view.isFulfilled()
            self.continueButton.backgroundColor = UIColor.lightSanGray
        }
    }

    func codeView(_ view: PLUIInputCodeView, willChange string: String, for position: NSInteger) -> Bool {
        if string.count == 0 { return true }
        guard string.count > 0,
              let character = UnicodeScalar(string),
              view.charactersSet.contains(character) == true else {
            return false
        }
        return true
    }

    func codeView(_ view: PLUIInputCodeView, didBeginEditing position: NSInteger) {
    }

    func codeView(_ view: PLUIInputCodeView, didEndEditing position: NSInteger) {
    }
}
