//
//  PhoneTransferRegistrationFormViewController.swift
//  BLIK
//
//  Created by 186491 on 22/07/2021.
//

import UI
import PLUI

protocol PhoneTransferRegistrationFormViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable {
    func setViewModel(_ viewModel: PhoneTransferRegistrationFormViewModel)
}

final class PhoneTransferRegistrationFormViewController: UIViewController, PhoneTransferRegistrationFormViewProtocol {
    private let presenter: PhoneTransferRegistrationFormPresenterProtocol
    
    private let scrollView = UIScrollView()
    private let infoLabel = UILabel()
    private let accountView = PhoneTransferRegistrationAccountView()
    private let phoneNumberView = PhoneTransferRegistrationPhoneView()
    private let statementTitleLabel = UILabel()
    private let statementLabel = UILabel()
    private let footerView = PhoneTransferRegistrationFooterView()
     
    init(
        presenter: PhoneTransferRegistrationFormPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
    
    func setViewModel(_ viewModel: PhoneTransferRegistrationFormViewModel) {
        infoLabel.text = viewModel.hintMessage
        statementTitleLabel.text = viewModel.statementViewModel.title
        statementLabel.text = viewModel.statementViewModel.description
        phoneNumberView.configure(with: viewModel.phoneViewModel)
        
        accountView.configure(with: viewModel.accountViewModel)
        accountView.setOnChangePress {[weak self] in
            self?.presenter.didPressChangeAccount()
        }
    }
}

private extension PhoneTransferRegistrationFormViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureTargets()
    }
    
    func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(infoLabel)
        scrollView.addSubview(accountView)
        scrollView.addSubview(phoneNumberView)
        scrollView.addSubview(statementTitleLabel)
        scrollView.addSubview(statementLabel)
        view.addSubview(footerView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        accountView.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberView.translatesAutoresizingMaskIntoConstraints = false
        statementTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        statementLabel.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            accountView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 32),
            accountView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            accountView.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            
            phoneNumberView.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 32),
            phoneNumberView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            phoneNumberView.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            
            statementTitleLabel.topAnchor.constraint(equalTo: phoneNumberView.bottomAnchor, constant: 32),
            statementTitleLabel.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            statementTitleLabel.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            
            statementLabel.topAnchor.constraint(equalTo: statementTitleLabel.bottomAnchor, constant: 16),
            statementLabel.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            statementLabel.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            statementLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
        
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.textColor = .lisboaGray
        infoLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
        infoLabel.setInterlineSpacing()
        
        
        statementTitleLabel.textColor = .lisboaGray
        statementTitleLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 17
        )
        
        statementLabel.numberOfLines = 0
        statementLabel.textColor = .lisboaGray
        statementLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
        statementLabel.setInterlineSpacing()
    }
    
    func configureTargets() {
        footerView.registerButtonTap = { [weak self] in
            self?.presenter.didPressRegister()
        }
    }
        
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "#Przelew na telefon"))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
}
