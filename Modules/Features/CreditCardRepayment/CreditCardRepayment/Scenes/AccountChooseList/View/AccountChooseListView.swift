//
//  AccountChooseListView.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//  

import UI
import Commons
import Foundation

final class AccountChooseListView: UIView {
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return tableView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        // TODO: Move color to the separate module
        let viewColor = UIColor(red: 215.0 / 255.0, green: 215.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        view.backgroundColor = viewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var topSeparatorViewConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTableView()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
        setupTableView()
        registerCells()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        addSubview(separatorView)
        topSeparatorViewConstraint = topAnchor.constraint(equalTo: separatorView.topAnchor)
        NSLayoutConstraint.activate([
            topSeparatorViewConstraint,
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorViewHeight),
            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            leftAnchor.constraint(equalTo: tableView.leftAnchor),
            rightAnchor.constraint(equalTo: tableView.rightAnchor),
            bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
    private func registerCells() {
        tableView.register(AccountChooseListCell.self, forCellReuseIdentifier: AccountChooseListCell.identifier)
    }

}

extension AccountChooseListView {
    
    private struct Constants {
        static let separatorViewHeight: CGFloat = 2.0
    }
    
}
