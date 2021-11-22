//
//  OneAppInitWelcomeViewController.swift
//  Santander
//
//  Created by 186484 on 22/06/2021.
//

import Foundation
import UIKit
import UI

protocol OneAppInitWelcomeDelegate: AnyObject {
    func selectLogin(_ type: OneAppInitLoginType)
}

final class OneAppInitWelcomeViewController: UIViewController {
    
    private weak var delegate: OneAppInitWelcomeDelegate?
    private let loginTypes: [OneAppInitLoginType]
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let tokenTextField = UITextField()
    
    init(loginTypes: [OneAppInitLoginType], delegate: OneAppInitWelcomeDelegate?) {
        self.loginTypes = loginTypes
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = .white
    }
    
    private func setUpSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        loginTypes.forEach { type in
            let button = RedLisboaButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            
            button.addAction { [weak self] in
                self?.delegate?.selectLogin(type)
            }
            button.setTitle(type.rawValue, for: .normal)
            stackView.addArrangedSubview(button)
        }
        
        let tokenTitleLabel = UILabel()
        tokenTitleLabel.text = "Token:"
        stackView.addArrangedSubview(tokenTitleLabel)
        
        tokenTextField.borderStyle = .bezel
        tokenTextField.addTarget(self, action: #selector(tokenTextChange), for: .editingChanged)
        stackView.addArrangedSubview(tokenTextField)
    }
    
    @objc private func tokenTextChange() {
        UserDefaults.standard.setValue(tokenTextField.text, forKey: "pl-temporary-simple-accessToken")
    }
    
    private func setUpLayouts() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let accessToken = UserDefaults.standard.string(forKey: "pl-temporary-simple-accessToken") {
            tokenTextField.text = accessToken
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        NavigationBarBuilder(style: .sky,
                             title: .title(key: "Login options"))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }
    
    @objc private func didSelectBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
