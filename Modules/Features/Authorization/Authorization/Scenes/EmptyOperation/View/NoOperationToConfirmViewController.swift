//
//  NoOperationToConfirmViewController.swift
//  Authorization
//
//  Created by 186484 on 15/04/2022.
//

import UI
import PLUI
import PLCommons
import CoreFoundationLib

protocol NoOperationToConfirmViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable {
    func setLabels(title: String, description: String)
}

final class NoOperationToConfirmViewController: UIViewController {
    private let presenter: NoOperationToConfirmPresenterProtocol
    private lazy var contentView = NoOperationToConfirmView()
    
    init(presenter: NoOperationToConfirmPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setUp() {
        prepareNavigationBar()
        prepareActions()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(
            style: .white,
            title: .title(key: localized("toolbar_title_mobileAuthorization")))
            .setLeftAction(.back(action: .closure(didSelectCloseProcess)))
            .setRightActions(.close(action: .closure(didSelectCloseProcess)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func prepareActions() {
        contentView.onRefreshTapped = { [weak self] in
            self?.presenter.refreshOperations()
        }
        
        contentView.onCloseTapped = { [weak self] in
            self?.didSelectCloseProcess()
        }
    }
    
    @objc func didSelectCloseProcess() {
        let dialog = AuthorizationDialogFactory.makeCloseDialog(
            onAccept: { [weak self] in
                self?.presenter.didConfirmClosing()
            }
        )
        dialog.showIn(self)
    }
}

extension NoOperationToConfirmViewController: NoOperationToConfirmViewProtocol {

    func setLabels(title: String, description: String) {
        contentView.setupLabels(title: title, description: description)
    }
    
}
