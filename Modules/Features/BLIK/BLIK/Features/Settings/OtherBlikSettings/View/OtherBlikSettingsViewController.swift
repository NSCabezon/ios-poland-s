//
//  OtherBlikSettingsViewController.swift
//  BLIK
//
//  Created by 186491 on 06/08/2021.
//

import UIKit
import UI
import PLUI
import CoreFoundationLib
import PLCommons

protocol OtherBlikSettingsViewProtocol: LoaderPresentable, ErrorPresentable, SnackbarPresentable, DialogViewPresentationCapable {
    func setViewModel(viewModel: OtherBlikSettingsViewModel)
}

final class OtherBlikSettingsViewController: UIViewController, OtherBlikSettingsViewProtocol {
    private let presenter: OtherBlikSettingsPresenterProtocol
    private let contentView = OtherBlikSettingsView()
    
    init(presenter: OtherBlikSettingsPresenterProtocol) {
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
}

private extension OtherBlikSettingsViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureDelegates()
        configureKeyboardDismissGesture()
    }
    
    func configureSubviews() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    func configureDelegates() {
        contentView.delegate = self
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_otherSetting")))
            .setLeftAction(.back(action: .selector(#selector(back))))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func back() {
        presenter.didPressBack()
    }
}

extension OtherBlikSettingsViewController: OtherBlikSettingsViewDelegate {
    func didUpdateVisibility() {
        presenter.didToggleTransactionVisibilitySwitch(
            isOn: contentView.isTransactionVisible
        )
    }
    
    func didTapBlikLabelEditButton() {
        presenter.didPressBlikLabelEdit()
    }
}
