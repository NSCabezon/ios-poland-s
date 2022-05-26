import Foundation
import UIKit
import UI
import UIOneComponents
import CoreFoundationLib
import SANPLLibrary

protocol PLQuickBalanceSetAccountDelegate: NSObject {
    func didSelect(_ index: Int)
}

public protocol PLQuickBalanceSetAccountViewControllerDelegate {
    func setMain(account: PLQuickBalanceSettingsAccountModel)
    func setSecond(account: PLQuickBalanceSettingsAccountModel?)
}

public enum PLQuickBalanceAccountType {
    case main
    case second
}

class PLQuickBalanceSetAccountViewController: UIViewController{
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private var viewModel: PLQuickBalanceSettingsViewModel
    var accountType: PLQuickBalanceAccountType
    var delegate: PLQuickBalanceSetAccountViewControllerDelegate?
    
    init(viewModel: PLQuickBalanceSettingsViewModel, delegate: PLQuickBalanceSetAccountViewControllerDelegate, accountType: PLQuickBalanceAccountType) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.accountType = accountType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_quickView_label_selectAcc")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = localized("pl_quickView_label_selectAcc") + ":"
        titleLabel.font = UIFont.santander(family: .text, type: .regular, size: 18)

        view.addSubview(tableView)
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PLQuickBalanceSetAccountCell.self, forCellReuseIdentifier: "PLQuickBalanceSetAccountCell")
        
        configureSubviews()
    }

    @objc private func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureSubviews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func accountsToShow() -> [PLQuickBalanceSettingsAccountModel]? {
        switch accountType {
        case .main:
            return self.viewModel.allAccounts
        case .second:
            return self.viewModel.allAccounts?.filter({ [weak self] account in
                account.id != self?.viewModel.selectedMainAccount?.id
            })
        }
    }
}

extension PLQuickBalanceSetAccountViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountsToShow()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "PLQuickBalanceSetAccountCell", for: indexPath) as? PLQuickBalanceSetAccountCell
        else {
            return UITableViewCell()
        }
        
        var selectedAcc: PLQuickBalanceSettingsAccountModel?
        switch accountType {
        case .main:
            selectedAcc = self.viewModel.selectedMainAccount
        case .second:
            selectedAcc = self.viewModel.selectedSecondAccount
        }
        
        
        if let account = accountsToShow()?[safe: indexPath.row] {
            let title = account.name
            let description = account.number
            let isActive = (account == selectedAcc)
            
            cell.fill(title: title,
                      description: description,
                      index: indexPath.row,
                      isSelected: isActive)
            cell.delegate = self
        }
        return cell
    }
    
}

extension PLQuickBalanceSetAccountViewController: PLQuickBalanceSetAccountDelegate {
    func didSelect(_ index: Int) {
        if let selectedAccount = accountsToShow()?[safe: index] {
            switch accountType {
            case .main:
                delegate?.setMain(account: selectedAccount)
            case .second:
                if self.viewModel.selectedSecondAccount == selectedAccount {
                    delegate?.setSecond(account: nil)
                } else {
                    delegate?.setSecond(account: selectedAccount)
                }
                
            }
            self.tableView.reloadData()
        }
    }
}
