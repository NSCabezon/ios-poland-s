//
//  BlikLabelSettingsViewController.swift
//  BLIK
//
//  Created by 185167 on 23/02/2022.
//

import UIKit
import UI
import PLUI
import CoreFoundationLib
import PLCommons

protocol BlikLabelSettingsView: LoaderPresentable, ErrorPresentable, SnackbarPresentable, DialogViewPresentationCapable {
    func setLabel(_ label: String)
    func setLabelValidationError(_ errorText: String?)
    func setSaveButtonState(isEnabled: Bool)
}

final class BlikLabelSettingsViewController: UIViewController, BlikLabelSettingsView {
    private let presenter: BlikLabelSettingsPresenterProtocol
    private let contentView = BlikLabelSettingsContentView()
    private let bottomButton = BottomButtonView()
    
    init(presenter: BlikLabelSettingsPresenterProtocol) {
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
    
    func setLabel(_ label: String) {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.configure(with: label)
        }
    }
    
    func setLabelValidationError(_ errorText: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.setLabelError(errorText)
        }
    }
    
    func setSaveButtonState(isEnabled isSaveButtonEnabled: Bool) {
        if isSaveButtonEnabled {
            bottomButton.enableButton()
        } else {
            bottomButton.disableButton()
        }
    }
}

private extension BlikLabelSettingsViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureTargets()
        configureDelegates()
        configureKeyboardDismissGesture()
        bottomButton.disableButton()
    }
    
    func configureSubviews() {
        [contentView, bottomButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            bottomButton.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    func configureDelegates() {
        contentView.setDelegate(self)
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_toolbar_blik_tag")))
            .setLeftAction(.back(action: .selector(#selector(back))))
            .setRightActions([.close(action: .selector(#selector(close)))])
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func configureTargets() {
        bottomButton.configure(title: localized("generic_button_save")) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.presenter.didPressSave(with: strongSelf.contentView.blikCustomerLabel)
        }
    }
    
    @objc func back() {
        presenter.didPressBack(with: contentView.blikCustomerLabel)
    }
    
    @objc func close() {
        presenter.didPressClose(with: contentView.blikCustomerLabel)
    }
}

extension BlikLabelSettingsViewController: BlikLabelSettingsContentViewDelegate {
    func didUpdateBlikLabel() {
        presenter.didUpdateForm(with: contentView.blikCustomerLabel)
    }
}
