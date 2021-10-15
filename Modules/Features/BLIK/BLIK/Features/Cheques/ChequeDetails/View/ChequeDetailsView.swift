//
//  ChequeDetailsView.swift
//  BLIK
//
//  Created by 186491 on 21/06/2021.
//

import UIKit

final class ChequeDetailsView: UIView {
    private(set) lazy var tableView = makeTableView()
    private(set) lazy var footerView = makeFooterView()
    
    init() {
        super.init(frame: .zero)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ChequeDetailsView {
    func buildUI() {
        backgroundColor = .white
        addSubview(tableView)
        addSubview(footerView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChequeDetailsCell.self, forCellReuseIdentifier: ChequeDetailsCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        return tableView
    }
    
    func makeFooterView() -> ChequeDetailsFooterView {
        let view = ChequeDetailsFooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
