//
//  PhoneTopUpFormViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 19/11/2021.
//

import UI
import PLUI
import Commons

protocol PhoneTopUpFormViewProtocol: AnyObject, ConfirmationDialogPresentable {
    func updateSelectedAccount(with accountModels: [SelectableAccountViewModel])
}

final class PhoneTopUpFormViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: PhoneTopUpFormPresenterProtocol
    private let mainStackView = UIStackView()
    private let formView = PhoneTopUpFormView()
    private let navigationBarSeparator = UIView()
    private let bottomButtonView = BottomButtonView(style: .red)
    
    // MARK: Lifecycle
    
    init(presenter: PhoneTopUpFormPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    // MARK: Configuration
    
    private func setUp() {
        prepareNavigationBar()
        addSubviews()
        setUpLayout()
        prepareStyles()
        formView.delegate = self
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("pl_topup_title_topup")))
            .setLeftAction(.back(action: #selector(goBack)))
            .setRightActions(.close(action: #selector(closeProcess)))
            .build(on: self, with: nil)
    }
    
    private func addSubviews() {
        view.addSubviewsConstraintToSafeAreaEdges(mainStackView)
        mainStackView.addArrangedSubview(navigationBarSeparator)
        mainStackView.addArrangedSubview(formView)
        mainStackView.addArrangedSubview(bottomButtonView)
    }
    
    private func setUpLayout() {
        mainStackView.axis = .vertical
        bottomButtonView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBarSeparator.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
        navigationBarSeparator.backgroundColor = .lightSanGray
        bottomButtonView.configure(title: localized("generic_button_continue")) {
            // TODO: Add ready botton action
        }
        bottomButtonView.disableButton()
    }
    
    // MARK: Actions
    
    @objc private func goBack() {
        presenter.didSelectBack()
    }
    
    @objc private func closeProcess() {
        presenter.didSelectClose()
    }
}

extension PhoneTopUpFormViewController: PhoneTopUpFormViewProtocol {
    func updateSelectedAccount(with accountModels: [SelectableAccountViewModel]) {
        formView.updateSelectedAccount(with: accountModels)
    }
}

extension PhoneTopUpFormViewController: PhoneTopUpFormViewDelegate {
    func topUpFormDidSelectChangeAccount() {
        presenter.didSelectChangeAccount()
    }
}
