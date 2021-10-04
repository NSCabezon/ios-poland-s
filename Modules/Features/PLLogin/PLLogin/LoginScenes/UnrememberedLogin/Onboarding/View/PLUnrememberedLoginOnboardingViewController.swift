//
//  PLUnrememberedLoginOnboardingViewController.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 20/9/21.
//

import Foundation
import PLCommons
import Commons
import UI

protocol PLUnrememberedLoginOnboardingProtocol: PLGenericErrorPresentableCapable {

}

final class PLUnrememberedLoginOnboardingViewController: UIViewController {
    
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLUnrememberedLoginOnboardingPresenter
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var lostKeyLabel: UILabel!
    @IBOutlet private weak var lostKeyTwoLabel: UILabel!
    @IBOutlet private weak var loginButton: PLLoginButton!
    @IBOutlet weak var createAccountButton: LisboaButton!

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLUnrememberedLoginOnboardingPresenter) {
        self.presenter = presenter
        self.dependenciesResolver = dependenciesResolver
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
}

private extension PLUnrememberedLoginOnboardingViewController {
    
    func setNavigationBar() {
        NavigationBarBuilder(style: .clear(tintColor: .white), title: .none)
            .setRightActions(.menu(action: #selector(didSelectMenu)))
            .build(on: self, with: nil)
    }
    
    @objc func didSelectMenu() {
//        self.presenter.didSelectMenu()
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
    
    func setupViews() {
        let timeImageAndGreeting = TimeImageAndGreetingViewModel()
        sanIconImageView?.image = Assets.image(named: "icnSanWhiteLisboa")
        backgroundImageView.image = timeImageAndGreeting.backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        
        titleLabel.font = .santander(family: .text, type: .light, size: 40)
        titleLabel.textColor = UIColor.Legacy.uiWhite
        titleLabel.text = localized(timeImageAndGreeting.greetingTextKey.rawValue)

        lostKeyLabel.font = .santander(family: .text, type: .regular, size: 14)
        lostKeyLabel.textColor = UIColor.Legacy.uiWhite
        lostKeyLabel.text = localized("pl_onboarding_text_activateApp")
        
        lostKeyTwoLabel.font = .santander(family: .text, type: .regular, size: 14)
        lostKeyTwoLabel.textColor = UIColor.Legacy.uiWhite
        lostKeyTwoLabel.text = localized("pl_onboarding_text_openAccount")
        lostKeyTwoLabel.numberOfLines = 2
        
        setupLoginButton()
        setupCreateAccountButton()
    }
    
    func setupLoginButton() {
        loginButton.set(localizedStylableText: localized("pl_onboarding_button_activateApp"), state: .normal)
        loginButton.setTitleColor(UIColor.Legacy.uiWhite, for: .normal)
        loginButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 16.0)
        loginButton.isEnabled = true
        loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLoginButtonSelected)))
    }
    
    func setupCreateAccountButton() {
        createAccountButton.set(localizedStylableText: localized("pl_onboarding_button_openAccount"), state: .normal)
        createAccountButton.setTitleColor(UIColor.santanderRed, for: .normal)
        createAccountButton.backgroundNormalColor = UIColor.white
        createAccountButton.backgroundPressedColor = .lightSanGray
        createAccountButton.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 16.0)
        createAccountButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCreateAccountButtonSelected)))
    }
    
    @objc func onLoginButtonSelected() {
        self.presenter.didSelectLogin()
    }
    
    @objc func onCreateAccountButtonSelected() {
        self.presenter.didSelectCreateAccount()
    }
}

extension PLUnrememberedLoginOnboardingViewController : PLUnrememberedLoginOnboardingProtocol {
    
}
