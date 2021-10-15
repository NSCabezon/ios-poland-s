//
//  OtherBlikSettingsViewController.swift
//  BLIK
//
//  Created by 186491 on 06/08/2021.
//

import UIKit
import UI
import PLUI
import Commons

protocol OtherBlikSettingsViewProtocol: LoaderPresentable, ErrorPresentable, SnackbarPresentable, DialogViewPresentationCapable {
    func setViewModel(viewModel: OtherBlikSettingsViewModel)
}

final class OtherBlikSettingsViewController: UIViewController, OtherBlikSettingsViewProtocol {
    
    private let presenter: OtherBlikSettingsPresenterProtocol
    private let contentView = OtherBlikSettingsView()
    private let footerView = OtherBlikSettingsFooterView()
    
    init(
        presenter: OtherBlikSettingsPresenterProtocol
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
    
    func setViewModel(viewModel: OtherBlikSettingsViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.set(viewModel: viewModel)
        }
    }
    
    func setIsSaveButtonEnabled(_ isEnabled: Bool) {
        footerView.setIsSaveButtonEnabled(isEnabled)
    }
}

private extension OtherBlikSettingsViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureTargets()
        configureDelegates()
        configureKeyboardDismissGesture()
    }
    
    func configureSubviews() {
        view.addSubview(contentView)
        view.addSubview(footerView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
        setIsSaveButtonEnabled(false)
    }
    
    func configureDelegates() {
        contentView.delegate = self
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_otherSetting")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func configureTargets() {
        footerView.saveButtonTap = { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.presenter.didPressSave(
                viewModel: OtherBlikSettingsViewModel(
                    blikCustomerLabel: strongSelf.contentView.blikCustomerLabel,
                    isTransactionVisible: strongSelf.contentView.isTransactionVisible
                )
            )
        }
    }
    
    @objc func close() {
        presenter.didPressClose(
            viewModel: OtherBlikSettingsViewModel(
                blikCustomerLabel: contentView.blikCustomerLabel,
                isTransactionVisible: contentView.isTransactionVisible
            )
        )
    }
}

extension OtherBlikSettingsViewController: OtherBlikSettingsViewDelegate {
    func didUpdateBlikLabel() {
        presenter.didUpdateForm(
            viewModel: OtherBlikSettingsViewModel(
                blikCustomerLabel: contentView.blikCustomerLabel,
                isTransactionVisible: contentView.isTransactionVisible
            )
        )
    }
    
    func didUpdateVisibility() {
        presenter.didUpdateForm(
            viewModel: OtherBlikSettingsViewModel(
                blikCustomerLabel: contentView.blikCustomerLabel,
                isTransactionVisible: contentView.isTransactionVisible
            )
        )
    }
}
