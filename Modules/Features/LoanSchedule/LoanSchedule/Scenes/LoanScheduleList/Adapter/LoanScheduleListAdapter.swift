//
//  LoanScheduleListAdapter.swift
//  LoanSchedule
//
//  Created by 186490 on 02/09/2021.
//

import UIKit

final class LoanScheduleListAdapter: NSObject {
    private var items = [LoanScheduleListItemViewModel]()
    private weak var tableView: UITableView?

    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }

    func setUp(items: [LoanScheduleListItemViewModel] = []) {
        self.items = items
        tableView?.reloadData()
    }
}

extension LoanScheduleListAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.removeUnnecessaryHeaderTopPadding()
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: LoanScheduleInformationHeaderView.identifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = items[safe: indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: LoanScheduleSingleRepaymentCell.identifier, for: indexPath) as? LoanScheduleSingleRepaymentCell
        else { return UITableViewCell() }
    
        cell.setUp(with: row)
        
        return cell
    }
}

extension LoanScheduleListAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = items[safe: indexPath.row] else { return }
        item.onItemTap()
    }
}
