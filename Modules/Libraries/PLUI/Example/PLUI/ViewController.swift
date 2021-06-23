//
//  ViewController.swift
//  PLUI
//
//  Created by Jose C. Yebes on 05/13/2021.
//  Copyright (c) 2021 Jose C. Yebes. All rights reserved.
//

import UIKit
import PLUI

class ViewController: UIViewController {

    private lazy var tableView: UITableView = {

        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    private enum Constants {
        static let reuseIdentifier = "Cell"
    }

    private var components = [Any]()

    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 204/256, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(self.tableView)

        components.append(self.maskedPasswordView())
        components.append(self.smsAuthenticationView())

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.components.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let component = self.components[section] as? UIView else {
            return nil
        }
        return String(describing: type(of: component))
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: Constants.reuseIdentifier)
        }
        guard let newCell = cell else { return UITableViewCell() }
        newCell.backgroundColor = .clear
        newCell.translatesAutoresizingMaskIntoConstraints = false
        newCell.selectionStyle = .none
        let component = self.componentForRow(indexPath: indexPath)
        newCell.contentView.addSubview(component)
        NSLayoutConstraint.activate([
            component.topAnchor.constraint(equalTo: newCell.contentView.topAnchor, constant: 10),
            component.bottomAnchor.constraint(equalTo: newCell.contentView.bottomAnchor, constant: -10),
            component.leadingAnchor.constraint(equalTo: newCell.contentView.leadingAnchor),
            component.trailingAnchor.constraint(equalTo: newCell.contentView.trailingAnchor)
        ])

        return newCell
    }
}

private extension ViewController {

    func componentForRow(indexPath: IndexPath) -> UIView {
        guard let component = self.components[indexPath.section] as? UIView else {
            return UIView()
        }

        return component
    }
}
