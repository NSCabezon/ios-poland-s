//
//  HelpCenterView.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//

import Commons
import PLUI
import UI

private enum Constants {
    // TODO: Move colors to the separate module
    static let backgroundColor = UIColor.white
}

final class HelpCenterView: UIView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
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
        setupTableView()
        registerHeaderFooter()
        registerCells()
    }
    
    private func setupSubviews() {
        addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorColor = .clear
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.backgroundColor = Constants.backgroundColor
    }
    
    private func registerHeaderFooter() {
        tableView.register(HelpCenterSectionHeader.self, forHeaderFooterViewReuseIdentifier: HelpCenterSectionHeader.identifier)
    }
    
    private func registerCells() {
        tableView.register(HelpCenterPlainCell.self, forCellReuseIdentifier: HelpCenterPlainCell.identifier)
        tableView.register(HelpCenterInfoCell.self, forCellReuseIdentifier: HelpCenterInfoCell.identifier)
        tableView.register(HelpCenterExpandableHintCell.self, forCellReuseIdentifier: HelpCenterExpandableHintCell.identifier)
    }

}
