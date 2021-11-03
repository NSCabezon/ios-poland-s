//
//  ChequeFormViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 06/07/2021.
//

import UI
import Commons
import PLUI

protocol ChequeFormViewProtocol: AnyObject, LoaderPresentable, SnackbarPresentable, ErrorPresentable {
    func getForm() -> ChequeForm
    func setViewModel(viewModel: ChequeFormViewModel)
    func showInvalidFormMessages(_ messages: InvalidChequeFormMessages)
    func clearValidationMessages()
}

final class ChequeFormViewController: UIViewController {
    private let formView = ChequeFormView()
    private let bottomButton = BottomButtonView()
    private let presenter: ChequeFormPresenterProtocol
    
    init(
        presenter: ChequeFormPresenterProtocol
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
        setUp()
        presenter.viewDidLoad()
    }
    
    private func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureBottomButton()
        configureKeyboardDismissGesture()
        applyStyling()
        bottomButton.disableButton()
    }
    
    private func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_newBlikCheque")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    private func configureSubviews() {
        view.addSubview(formView)
        view.addSubview(bottomButton)
        
        formView.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            formView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor),
            
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func applyStyling() {
        view.backgroundColor = .white
    }
    
    private func configureBottomButton() {
        bottomButton.configure(title: localized("pl_blik_button_createCheque")) { [weak self] in
            self?.presenter.didPressCreate()
        }
    }
}

extension ChequeFormViewController: ChequeFormViewDelegate {
    func didUpdateText() {
        presenter.didUpdateText()
    }
}

extension ChequeFormViewController: ChequeFormViewProtocol {
    func getForm() -> ChequeForm {
        return formView.getCurrentForm()
    }
    
    func setViewModel(viewModel: ChequeFormViewModel) {
        formView.setViewModel(viewModel: viewModel, withDelegate: self)
    }
    
    func showInvalidFormMessages(_ messages: InvalidChequeFormMessages) {
        formView.showInvalidFormMessages(messages)
        bottomButton.disableButton()
    }
    
    func clearValidationMessages() {
        formView.clearValidationMessages()
        bottomButton.enableButton()
    }
}
