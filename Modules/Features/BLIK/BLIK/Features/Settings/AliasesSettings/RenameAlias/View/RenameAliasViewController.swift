//
//  RenameAliasViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 08/09/2021.
//

import Commons
import UI
import PLUI

protocol RenameAliasView: AnyObject, LoaderPresentable, ErrorPresentable, ConfirmationDialogPresentable {
    func setAliasLabel(_ label: String)
    func setAliasLabelError(_ errorMessage: String?)
}

final class RenameAliasViewController: UIViewController {
    private let aliasLabelTextField = LisboaTextFieldWithErrorView()
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
    }
}

extension RenameAliasViewController: RenameAliasView {
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
}

private extension RenameAliasViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureTextField()
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
        [aliasLabelTextField, bottomButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            aliasLabelTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            aliasLabelTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            aliasLabelTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            bottomButton.topAnchor.constraint(greaterThanOrEqualTo: aliasLabelTextField.bottomAnchor, constant: 0),
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
    }
    
    func configureBottomButton() {
        bottomButton.configure(title: localized("generic_button_save")) { [weak self] in
            let label = self?.aliasLabelTextField.textField.text ?? ""
            self?.presenter.didPressSave(with: label)
        }
    }
}
