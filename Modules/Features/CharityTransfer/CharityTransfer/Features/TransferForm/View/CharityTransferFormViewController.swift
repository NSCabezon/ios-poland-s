//
//  CharityTransferFormViewController.swift
//  CharityTransfer
//
//  Created by 187125 on 22/09/2021.
//

import UI
import PLUI
import Commons

protocol CharityTransferFormViewProtocol: AnyObject,
                                          ConfirmationDialogPresentable {
    func setAccountViewModel()
}

final class CharityTransferFormViewController: UIViewController {
    private let presenter: CharityTransferFormPresenterProtocol
    private let scrollView = UIScrollView()
    private let formView = CharityTransferFormView()
    private let bottomView = BottomButtonView(style: .red)
    
    init(presenter: CharityTransferFormPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
    }
}

private extension CharityTransferFormViewController {
    
    @objc func goBack() {
        presenter.didSelectClose()
    }
    
    @objc func closeProcess() {
        presenter.didSelectCloseProcess()
    }
    
    func setUp() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        setUpLayout()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(formView)
        view.addSubview(bottomView)
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("pl_foundtrans_title_foundTransfer")))
            .setLeftAction(.back(action: #selector(goBack)))
            .setRightActions(.close(action: #selector(closeProcess)))
            .build(on: self, with: nil)
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
        bottomView.configure(title: localized("pl_foundtrans_button_doneTransfer")) {
            // TODO: Add ready botton action
        }
        bottomView.disableButton()
        formView.configure(with: presenter.getAccounts())
        formView.delegate = self
    }
    
    func setUpLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        formView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            formView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            formView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            formView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -16),
            formView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CharityTransferFormViewController: CharityTransferFormViewProtocol {
    func setAccountViewModel() {
        formView.configure(with: presenter.getAccounts())
    }
}

extension CharityTransferFormViewController: CharityTransferFormViewDelegate {
    func changeAccountTapped() {
        presenter.showAccountSelector()
    }
}