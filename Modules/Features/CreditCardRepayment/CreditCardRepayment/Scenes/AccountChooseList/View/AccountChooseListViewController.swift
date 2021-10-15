//
//  AccountChooseListViewController.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//  

import UI
import Commons
import Foundation

protocol AccountChooseListViewProtocol: GenericErrorDialogPresentationCapable {
    func setup(with accounts: [AccountChooseListViewModel])
    func showError(closeAction: (() -> Void)?)
}

final class AccountChooseListViewController: UIViewController {
    private let presenter: AccountChooseListPresenterProtocol
    private lazy var contentView = AccountChooseListView()
    private var accounts: [AccountChooseListViewModel] = [] {
        didSet {
            contentView.tableView.reloadData()
        }
    }
    
    init(presenter: AccountChooseListPresenterProtocol) {
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
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.topSeparatorViewConstraint.constant = -self.topbarHeight
        self.presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_creditCard_title_repSourceAccount")))
            .setRightActions(.close(action: #selector(didSelectClose)))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }

}

extension AccountChooseListViewController: AccountChooseListViewProtocol {
    
    func setup(with accounts: [AccountChooseListViewModel]) {
        self.accounts = accounts
    }
    
    func showError(closeAction: (() -> Void)?) {
        showGenericErrorDialog(withDependenciesResolver: presenter.dependenciesResolver, closeAction: closeAction)
    }
    
}

private extension AccountChooseListViewController {
    
    @objc func didSelectClose() {
        let dialog = CreditCardRepaymentDetailsDialogFactory.makeCloseDialog(
            onAccept: { [weak self] in
                self?.presenter.didConfirmClosing()
            }
        )
        dialog.showIn(self)
    }
    
    @objc func didSelectBack() {
        presenter.backButtonSelected()
    }

}

extension AccountChooseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AccountChooseListCell {
            cell.isSelected = true
        }
        presenter.didSelectItem(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AccountChooseListCell {
            cell.isSelected = false
        }
    }
    
}

extension AccountChooseListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(AccountChooseListCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        if let account = accounts[safe: indexPath.row] {
            cell.setup(with: account)
        }

        return cell
    }
    
}
