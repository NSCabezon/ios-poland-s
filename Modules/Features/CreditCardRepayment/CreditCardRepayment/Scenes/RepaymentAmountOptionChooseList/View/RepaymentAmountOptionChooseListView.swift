//
//  RepaymentAmountOptionChooseListView.swift
//  Pods
//
//  Created by 186484 on 07/06/2021.
//

import UI
import CoreFoundationLib
import Foundation

final class RepaymentAmountOptionChooseListView: UIView {
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        return tableView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        // TODO: Move color to the separate module
        let viewColor = UIColor(red: 215.0 / 255.0, green: 215.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        view.backgroundColor = viewColor
        return view
    }()
    
    var topSeparatorViewConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
        setup()
        registerCells()
    }
        
    private func registerCells() {
        tableView.register(RepaymentAmountOptionChooseListCell.self, forCellReuseIdentifier: RepaymentAmountOptionChooseListCell.identifier)
    }
}

private extension RepaymentAmountOptionChooseListView {
    
    private func setup() {
        addSubviews()
        prepareLayout()
    }
    
    private func addSubviews() {
        addSubview(tableView)
        addSubview(separatorView)
    }
    
    private func prepareLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorViewConstraint = topAnchor.constraint(equalTo: separatorView.topAnchor)
        
        NSLayoutConstraint.activate([
            topSeparatorViewConstraint,
            separatorView.heightAnchor.constraint(equalToConstant: 2.0),
            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            
            topAnchor.constraint(equalTo: tableView.topAnchor),
            leftAnchor.constraint(equalTo: tableView.leftAnchor),
            rightAnchor.constraint(equalTo: tableView.rightAnchor),
            bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
}
