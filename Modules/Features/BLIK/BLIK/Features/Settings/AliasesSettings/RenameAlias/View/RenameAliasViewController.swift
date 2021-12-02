//
//  RenameAliasViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 08/09/2021.
//

import Commons
import UI
import PLUI
import PLCommons

protocol RenameAliasViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable, ConfirmationDialogPresentable {
    func setAliasLabel(_ label: String)
    func setAliasLabelError(_ errorMessage: String?)
    func showInvalidFormMessages(_ messages: InvalidAliasChangeNameMessages)
    func clearValidationMessages()
}

final class RenameAliasViewController: UIViewController {
    private let aliasLabelTextField = LisboaTextFieldWithErrorView()
    private let aliasCharactersLimit = UILabel()
    private let bottomButton = BottomButtonView()
    private let presenter: RenameAliasPresenterProtocol
    
    init(
        presenter: RenameAliasPresenterProtocol
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
        configureDelegates()
    }
    
    private func configureDelegates() {
        aliasLabelTextField.textField.updatableDelegate = self
    }
}

extension RenameAliasViewController: RenameAliasViewProtocol {
    func setAliasLabel(_ label: String) {
        DispatchQueue.main.async {
            self.aliasLabelTextField.textField.setText(label)
        }
    }
    
    func setAliasLabelError(_ errorMessage: String?) {
        DispatchQueue.main.async {
            if let error = errorMessage {
                self.aliasLabelTextField.showError(error)
            } else {
                self.aliasLabelTextField.hideError()
            }
        }
    }
    
    func showInvalidFormMessages(_ messages: InvalidAliasChangeNameMessages) {
        if messages.invalidNameMessage == nil {
            aliasLabelTextField.hideError()
        } else {
            aliasLabelTextField.showError(messages.invalidNameMessage)
        }
        bottomButton.disableButton()
    }
    
    func clearValidationMessages() {
        aliasLabelTextField.hideError()
        bottomButton.enableButton()
    }
}

private extension RenameAliasViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureTextField()
        configureAliasCharactersLimit()
        configureBottomButton()
        configureKeyboardDismissGesture()
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_changeName")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose(with: aliasLabelTextField.textField.text ?? "")
    }
    
    func configureSubviews() {
        [aliasLabelTextField, aliasCharactersLimit, bottomButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            aliasLabelTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            aliasLabelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            aliasLabelTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            aliasCharactersLimit.topAnchor.constraint(equalTo: aliasLabelTextField.bottomAnchor, constant: 8),
            aliasCharactersLimit.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            aliasCharactersLimit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    func configureTextField() {
        aliasLabelTextField.textField.placeholder = localized("pl_blik_label_newName")
        
        let nameFormatter = AliasNameTextFieldFormatter(maxLength: 20)
        aliasLabelTextField.textField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .floatingTitle,
                    formatter: nameFormatter,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: nil
                )
            )
        )
    }
    
    func configureAliasCharactersLimit() {
        aliasCharactersLimit.textColor = .brownishGray
        aliasCharactersLimit.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        aliasCharactersLimit.numberOfLines = 1
        aliasCharactersLimit.text = localized("pl_blik_text_aliasMaxSign")
    }
    
    func configureBottomButton() {
        bottomButton.configure(title: localized("generic_button_save")) { [weak self] in
            let label = self?.aliasLabelTextField.textField.text ?? ""
            self?.presenter.didPressSave(with: label)
        }
    }
}

extension RenameAliasViewController: UpdatableTextFieldDelegate{
    func updatableTextFieldDidUpdate() {
        presenter.didUpdateNameAlias(name: aliasLabelTextField.textField.text)
    }
}
