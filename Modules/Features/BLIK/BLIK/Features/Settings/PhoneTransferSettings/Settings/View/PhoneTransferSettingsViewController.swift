//
//  PhoneTransferSettingsViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 22/07/2021.
//

import UI
import Commons
import PLUI

protocol PhoneTransferSettingsView: AnyObject, LoaderPresentable, ErrorPresentable {
    func setViewModel(_ viewModel: PhoneTransferSettingsViewModel)
}

final class PhoneTransferSettingsViewController: UIViewController {
    private let initialViewModel: PhoneTransferSettingsViewModel
    private let presenter: PhoneTransferSettingsPresenterProtocol
    private let icon = UIImageView()
    private let titleText = UILabel()
    private let userMessage = UILabel()
    private let singleButtonView = BottomButtonView()
    private let dualButtonView = BottomDualButtonView(firstButtonStyle: .white, secondButtonStyle: .white)
    private lazy var singleButtonTopConstraint: NSLayoutConstraint = {
        return singleButtonView.topAnchor.constraint(greaterThanOrEqualTo: userMessage.bottomAnchor, constant: 0)
    }()
    private lazy var dualButtonTopConstraint: NSLayoutConstraint = {
        return singleButtonView.topAnchor.constraint(greaterThanOrEqualTo: userMessage.bottomAnchor, constant: 0)
    }()
    
    init(
        initialViewModel: PhoneTransferSettingsViewModel,
        presenter: PhoneTransferSettingsPresenterProtocol
    ) {
        self.initialViewModel = initialViewModel
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension PhoneTransferSettingsViewController: PhoneTransferSettingsView {
    func setViewModel(_ viewModel: PhoneTransferSettingsViewModel) {
        DispatchQueue.main.async {
            self.icon.image = viewModel.icon
            self.titleText.text = viewModel.title
            self.userMessage.text = viewModel.userMessage
            
            switch viewModel {
            case .unregisteredPhoneNumber:
                self.configureUnregisteredPhoneNumberLayout()
            case .registeredPhoneNumber:
                self.configureRegisteredPhoneNumberLayout()
            case .expiredPhoneNumber:
                self.configureExpiredPhoneNumberLayout()
            }
        }
    }
}

private extension PhoneTransferSettingsViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        setViewModel(initialViewModel)
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "pl_blik_title_payMobile"))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    func configureSubviews() {
        view.addSubview(icon)
        view.addSubview(titleText)
        view.addSubview(userMessage)
        view.addSubview(singleButtonView)
        view.addSubview(dualButtonView)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        titleText.translatesAutoresizingMaskIntoConstraints = false
        userMessage.translatesAutoresizingMaskIntoConstraints = false
        singleButtonView.translatesAutoresizingMaskIntoConstraints = false
        dualButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 50),
            icon.heightAnchor.constraint(equalToConstant: 50),
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            
            titleText.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16),
            titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            userMessage.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 24),
            userMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userMessage.bottomAnchor.constraint(lessThanOrEqualTo: singleButtonView.topAnchor, constant: 0),
            
            singleButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            singleButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            singleButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            dualButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dualButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dualButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
        
        titleText.textAlignment = .center
        titleText.textColor = .lisboaGray
        titleText.font = .santander(
            family: .micro,
            type: .bold,
            size: 18
        )
        
        userMessage.numberOfLines = 0
        userMessage.textAlignment = .center
        userMessage.textColor = .lisboaGray
        userMessage.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
    }
    
    private func configureUnregisteredPhoneNumberLayout() {
        activateSingleButtonLayout()
        singleButtonView.configure(title: localized("pl_blik_button_registerNumb")) { [weak self] in
            self?.presenter.didPressRegisterPhoneNumber()
        }
    }
    
    private func configureRegisteredPhoneNumberLayout() {
        activateDualButtonLayout()
        let firstButtonViewModel = BottomButtonViewModel(title: localized("pl_blik_button_deleteNumb")) { [weak self] in
            self?.presenter.didPressRemovePhoneNumber()
        }
        let secondButtonViewModel = BottomButtonViewModel(title: localized("pl_blik_button_changeAccount")) { [weak self] in
            self?.presenter.didPressUpdateAccountNumber()
        }
        dualButtonView.configure(
            firstButtonViewModel: firstButtonViewModel,
            secondButtonViewModel: secondButtonViewModel
        )
    }
    
    private func configureExpiredPhoneNumberLayout() {
        activateSingleButtonLayout()
        singleButtonView.configure(title: localized("pl_blik_button_updateNumb")) { [weak self] in
            self?.presenter.didPressUpdatePhoneNumber()
        }
    }
    
    private func activateSingleButtonLayout() {
        singleButtonTopConstraint.isActive = true
        dualButtonTopConstraint.isActive = false
        singleButtonView.isHidden = false
        dualButtonView.isHidden = true
    }
    
    private func activateDualButtonLayout() {
        singleButtonTopConstraint.isActive = false
        dualButtonTopConstraint.isActive = true
        singleButtonView.isHidden = true
        dualButtonView.isHidden = false
    }
}
