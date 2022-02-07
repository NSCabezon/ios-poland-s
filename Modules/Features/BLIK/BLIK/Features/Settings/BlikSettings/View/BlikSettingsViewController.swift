//
//  BlikSettingsViewController.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 20/07/2021.
//

import UI
import PLUI
import CoreFoundationLib
import PLCommons

protocol BlikSettingsView: AnyObject, LoaderPresentable, ErrorPresentable {}

final class BlikSettingsViewController: UIViewController {
    private let presenter: BlikSettingsPresenterProtocol
    private let viewModels: [BlikSettingsViewModel]
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let menuView = BlikSettingsMenuView()

    init(
        presenter: BlikSettingsPresenterProtocol,
        viewModels: [BlikSettingsViewModel]
    ) {
        self.presenter = presenter
        self.viewModels = viewModels
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

extension BlikSettingsViewController: BlikSettingsView {}

private extension BlikSettingsViewController {
    func setUp() {
        configureSubviews()
        configureNavigationItem()
        configureStyling()
        configureActions()
        configureMenu()
        configureKeyboardDismissGesture()
    }
    
    func configureSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(menuView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_blikSetting")))
            .setLeftAction(.back(action: #selector(back)))
            .setRightActions(.close(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func back() {
        presenter.didTapBack()
    }
    
    @objc func close() {
        presenter.didTapClose()
    }
    
    func configureStyling() {
        view.backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 18, left: 18, bottom: 18, right: 18)
    }
    
    func configureActions() {
        menuView.onItemTapped = { [weak self] item in
            self?.presenter.didSelectSettingsItem(with: item)
        }
    }
    
    func configureMenu() {
        menuView.setItems(viewModels)
    }
}
