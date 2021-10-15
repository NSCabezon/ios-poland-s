//
//  HelpCenterAdapter.swift
//  HelpCenter
//
//  Created by 186490 on 05/08/2021.
//

import UIKit

final class HelpCenterAdapter: NSObject {
    private var viewModels = [HelpCenterSectionViewModel]()
    private weak var tableView: UITableView?
    private var expandedCellIndex: IndexPath?

    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }

    func setUp(with viewModels: [HelpCenterSectionViewModel]) {
        self.viewModels = viewModels
        tableView?.reloadData()
    }
}

extension HelpCenterAdapter: UITableViewDataSource {
    // sections
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModels.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionViewModel = viewModels[safe: section], sectionViewModel.isHeaderVisible else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionViewModel.identifier)
        if let header = header as? SectionViewModelSetUpable {
            header.setUp(with: sectionViewModel)
        }

        return header
    }

    // rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let elementViewModel = viewModels[safe: indexPath.section]?.elements[safe: indexPath.row] else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: elementViewModel.identifier, for: indexPath)
        cell.selectionStyle = .none
        if let cell = cell as? ElementViewModelSetUpable {
            cell.setUp(with: elementViewModel)
        }
        
        if let cell = cell as? SectionViewModelExpandable {
            cell.setExpanded(expandedCellIndex == indexPath, animated: false)
        }
        
        if let cell = cell as? SectionViewModelSeparatorSetapable {
            cell.setSeparatorVisible(!tableView.isLastRowInSection(indexPath: indexPath))
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels[safe: section]?.elements.count ?? 0
    }

}

extension HelpCenterAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let elementViewModel = viewModels[safe: indexPath.section]?.elements[safe: indexPath.row] else { return }
        
        elementViewModel.action()
        
        if let currentCell = tableView.cellForRow(at: indexPath) as? SectionViewModelExpandable {
            let previousIndex = expandedCellIndex
            expandedCellIndex = expandedCellIndex == indexPath ? nil : indexPath
            
            let expandAction = { [weak self] in
                guard let self = self else { return }
                if let previousIndex = previousIndex,
                   let previousCell = tableView.cellForRow(at: previousIndex) as? SectionViewModelExpandable {
                    previousCell.setExpanded(false, animated: true)
                }
                currentCell.setExpanded(self.expandedCellIndex == indexPath, animated: true)
            }
            tableView.performBatchUpdates({expandAction()}, completion: nil)
        }
    }
    
}

private extension HelpCenterSectionViewModel {
    var identifier: String {
        return HelpCenterSectionHeader.identifier
    }
    
    var isHeaderVisible: Bool {
        switch sectionType {
        case .hints, .inAppActions, .call, .onlineAdvisor, .mail, .conversationTopic:
            return true
        case .contact:
            return false
        }
    }
}

private extension HelpCenterElementViewModel {
    var identifier: String {
        switch element {
        case .blockCard, .yourCases, .mailContact, .call, .advisor, .subject:
            return HelpCenterPlainCell.identifier
        case .info:
            return HelpCenterInfoCell.identifier
        case .expandableHint:
            return HelpCenterExpandableHintCell.identifier
        }
    }
}

private extension UITableView {
    func isLastRowInSection(indexPath: IndexPath) -> Bool {
        indexPath.row == numberOfRows(inSection: indexPath.section) - 1
    }
}
