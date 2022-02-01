//
//  NotificationsInboxListViewController.swift
//  NotificationsInbox
//

import UI
import CoreFoundationLib
import Foundation

protocol NotificationsInboxListViewProtocol: GenericErrorDialogPresentationCapable, LoadingViewPresentationCapable {
    // TODO: In future user story
}

final class NotificationsInboxListViewController: UIViewController {
    private let presenter: NotificationsInboxListPresenterProtocol
    private lazy var contentView = NotificationsInboxListView()
    
    init(presenter: NotificationsInboxListPresenterProtocol) {
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
        presenter.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: "#Notifications List"))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }

}

extension NotificationsInboxListViewController: NotificationsInboxListViewProtocol {
    
    // TODO: In future user story
}

private extension NotificationsInboxListViewController {
    
    @objc func didSelectBack() {
        presenter.backButtonSelected()
    }
}

