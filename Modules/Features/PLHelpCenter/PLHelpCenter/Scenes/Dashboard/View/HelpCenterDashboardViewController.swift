//
//  HelpCenterViewController.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//  

import UI
import Commons
import Foundation

protocol HelpCenterDashboardViewProtocol: GenericErrorDialogPresentationCapable, LoadingViewPresentationCapable {
    func setSceneType(_ sceneType: HelpCenterSceneType)
    func setup(with viewModels: [HelpCenterSectionViewModel])
    func showErrorDialog()
}

final class HelpCenterDashboardViewController: UIViewController {
    private let presenter: HelpCenterDashboardPresenterProtocol
    private lazy var contentView = HelpCenterView()
    private lazy var adapter = HelpCenterAdapter(tableView: contentView.tableView)
    
    init(presenter: HelpCenterDashboardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
        
        setUpAdapter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        
        self.presenter.viewWillAppear()
    }
    
    func setupNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: "")) // Proper title is set by presenter
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }
    
    private func setUpAdapter() {
        adapter.setUp(with: [])
    }
}

extension HelpCenterDashboardViewController: HelpCenterDashboardViewProtocol {
    func setSceneType(_ sceneType: HelpCenterSceneType) {
        var builder = NavigationBarBuilder(style: .white, title: .title(key: sceneType.title))
            .setLeftAction(.back(action: #selector(didSelectBack)))
        if sceneType == .dashboard {
            builder = builder.setRightActions(.menu(action: #selector(didSelectMenu)))
        }
        builder
            .build(on: self, with: nil)
    }
    
    @objc func didSelectMenu() {
        presenter.didSelectMenu()
    }
    
    func setup(with viewModels: [HelpCenterSectionViewModel]) {
        adapter.setUp(with: viewModels)
    }
    
    func showErrorDialog() {
        let errorDialog = HelpCenterDialogFactory.makeErrorDialog()
        errorDialog.showIn(self)
    }
}

private extension HelpCenterDashboardViewController {
    
    @objc func didSelectBack() {
        presenter.backButtonSelected()
    }
}

private extension HelpCenterSceneType {
    var title: String {
        switch self {
        case .dashboard: return localized("pl_helpdesk_title_helpcenter")
        case .contact: return localized("pl_helpdesk_title_contact")
        }
    }
}
