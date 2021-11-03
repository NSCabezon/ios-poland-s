//
//  CreditCardChooseListViewController.swift
//  Pods
//
//  Created by 186490 on 01/06/2021.
//  

import UI
import Commons
import Foundation
import Operative

protocol CreditCardChooseListViewProtocol: OperativeView {
    func setup(with creditCards: [CreditCardChooseListViewModel])
    func showError(closeAction: (() -> Void)?)
}

final class CreditCardChooseListViewController: UIViewController {
    private let presenter: CreditCardChooseListPresenterProtocol
    private lazy var contentView = CreditCardChooseListView()
    private var creditCards: [CreditCardChooseListViewModel] = [] {
        didSet {
            contentView.tableView.reloadData()
        }
    }
    
    init(presenter: CreditCardChooseListPresenterProtocol) {
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
        setupNavigationBar()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.operativeViewWillDisappear()
    }
    
    func setupNavigationBar() {
        NavigationBarBuilder(style: .sky,
                             title: .title(key: localized("pl_creditCard_title_creditCardRepay")))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .setRightActions(.close(action: #selector(didSelectClose)))
            .build(on: self, with: self.presenter)
    }
}

extension CreditCardChooseListViewController: CreditCardChooseListViewProtocol {
    func setup(with creditCards: [CreditCardChooseListViewModel]) {
        self.creditCards = creditCards
    }
    
    func showError(closeAction: (() -> Void)?) {
        showGenericErrorDialog(withDependenciesResolver: presenter.dependenciesResolver, closeAction: closeAction)
    }
    
    var operativePresenter: OperativeStepPresenterProtocol {
        presenter
    }    
}

private extension CreditCardChooseListViewController {
    
    @objc func didSelectClose() {
        let dialog = CreditCardRepaymentDetailsDialogFactory.makeCloseDialog(
            onAccept: { [weak self] in
                self?.presenter.didConfirmClosing()
            }
        )
        dialog.showIn(self)
    }
    
    @objc private func didSelectBack() {
        presenter.backButtonSelected()
    }
}

extension CreditCardChooseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath)
    }
    
}

extension CreditCardChooseListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CreditCardTableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        if let creditCard = creditCards[safe: indexPath.row] {
            cell.setup(with: creditCard)
        }
        return cell
    }
    
}
