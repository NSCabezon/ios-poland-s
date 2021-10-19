//
//  CreditCardChooseListView.swift
//  Pods
//
//  Created by 186490 on 01/06/2021.
//  

import UI
import PLUI
import Commons
import Foundation

final class CreditCardChooseListView: UIView {
    
    private let headerView = NavigationBarBottomExtendView()
    private let headerLabel = UILabel()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupSubviews()
        setupLayout()
        setupStyle()
        setupHeaderLabel()
        setupTableView()
        registerCells()
    }
    
    private func setupSubviews() {
        addSubview(headerView)
        headerView.addSubview(headerLabel)
        addSubview(tableView)
    }
    
    private func setupLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: leftAnchor),
            headerView.rightAnchor.constraint(equalTo: rightAnchor),
            headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16),
            headerLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 17),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -17),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupStyle() {
        backgroundColor = .white
        
        headerLabel.applyStyle(LabelStylist(textColor: .greyishBrown,
                                      font: UIFont.santander(family: .micro, type: .regular, size: 14.0),
                                      textAlignment: .left))
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    private func setupTableView() {
        tableView.allowsSelection = true
    }
    
    private func setupHeaderLabel() {
        headerLabel.text = localized("pl_creditCard_label_repChoseCard")
    }
    
    private func registerCells() {
        tableView.register(CreditCardTableViewCell.self, forCellReuseIdentifier: CreditCardTableViewCell.identifier)
    }
}
