//
//  RepaymentAmountOptionChooseListViewController.swift
//  Pods
//
//  Created by 186484 on 07/06/2021.
//  

import UI
import Commons
import Foundation

protocol RepaymentAmountOptionChooseListViewProtocol: GenericErrorDialogPresentationCapable {
    func reloadTableView()
}

final class RepaymentAmountOptionChooseListViewController: UIViewController {
    private let presenter: RepaymentAmountOptionChooseListPresenterProtocol
    private lazy var contentView = RepaymentAmountOptionChooseListView()
    
    init(presenter: RepaymentAmountOptionChooseListPresenterProtocol) {
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
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_creditCard_title_repType")))
            .setRightActions(.close(action: #selector(didSelectClose)))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }
}

extension RepaymentAmountOptionChooseListViewController: RepaymentAmountOptionChooseListViewProtocol {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.contentView.tableView.reloadData()
        }
    }
}

private extension RepaymentAmountOptionChooseListViewController {
    
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

extension RepaymentAmountOptionChooseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RepaymentAmountOptionChooseListCell {
            cell.isSelected = true
        }
        presenter.didSelectItem(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RepaymentAmountOptionChooseListCell {
            cell.isSelected = false
        }
    }
    
}

extension RepaymentAmountOptionChooseListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.repayments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RepaymentAmountOptionChooseListCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        guard let account = presenter.repayments[safe: indexPath.row] else { return cell }
        cell.setup(with: account)
        
        return cell
    }
    
}
