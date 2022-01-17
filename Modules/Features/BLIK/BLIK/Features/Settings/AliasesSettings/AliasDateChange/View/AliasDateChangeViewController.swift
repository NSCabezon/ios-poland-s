//
//  AliasDateChangeViewController.swift
//  BLIK
//
//  Created by 186491 on 17/09/2021.
//

import Commons
import UI
import PLUI
import PLCommons

protocol AliasDateChangeView: AnyObject, LoaderPresentable, ErrorPresentable {
    var validityPeriod: AliasDateValidityPeriod? { get }
    func set(_ viewModel: AliasDateChangeViewModel)
}

final class AliasDateChangeViewController: UIViewController {
    private let presenter: AliasDateChangePresenterProtocol
    private var viewModel: AliasDateChangeViewModel
    private let footerView = AliasDateChangeFooterView()
    private let contentView = AliasDateChangeContentView()
    
    var validityPeriod: AliasDateValidityPeriod? {
        contentView.selectedPeriod
    }
    
    init(presenter: AliasDateChangePresenterProtocol, viewModel: AliasDateChangeViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
        
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
    
}

private extension AliasDateChangeViewController {
    func setUp() {
        configureSubviews()
        configureNavigationItem()
        configureStyling()
        configureDelegates()
        configureSaveButton()
    }
    
    func configureSubviews() {
        [contentView, footerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            footerView.topAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "pl_blik_title_setDateExpir"))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func configureDelegates() {
        contentView.delegate = self
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    func configureSaveButton() {
        footerView.saveButtonTap = { [weak self] in
            self?.presenter.didPressSave()
        }
        
        footerView.setIsSaveButtonEnabled(false)
    }
}

extension AliasDateChangeViewController: AliasDateChangeView {
    func set(_ viewModel: AliasDateChangeViewModel) {
        contentView.set(viewModel: viewModel)
    }
}

extension AliasDateChangeViewController: AliasDateChangeContentViewDelegate {
    func didUpdateDate() {
        footerView.setIsSaveButtonEnabled(true)
    }
}
