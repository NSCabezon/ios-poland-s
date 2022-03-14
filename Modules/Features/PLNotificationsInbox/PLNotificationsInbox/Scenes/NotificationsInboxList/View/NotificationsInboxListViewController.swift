//
//  NotificationsInboxListViewController.swift
//  NotificationsInbox
//

import UI
import PLUI
import CoreFoundationLib
import Foundation
import UIOneComponents
import CoreMedia
import SANPLLibrary
import UIKit

protocol NotificationsInboxListViewProtocol: GenericErrorDialogPresentationCapable, LoadingViewPresentationCapable {
    func getNotificationsInboxListView() -> NotificationsInboxListView
}

protocol NotificationsInboxListViewControllerDelegate {
    func refreshDataWithFilters(_ filters: [EnabledPushCategorie],_ statuses: [NotificationStatus])
}

final class NotificationsInboxListViewController: UIViewController {
    private var presenter: NotificationsInboxListPresenterProtocol
    private var lastPushId: Int?
    private lazy var contentView = NotificationsInboxListView()
    private var selectedPushCategories: [EnabledPushCategorie]?
    private var selectedPushStatuses: [NotificationStatus]?
    private var isLoadingNextPage = false
    init(presenter: NotificationsInboxListPresenterProtocol) {
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
        
        setUpFilterButton()
        
        getData(selectedPushCategories ?? EnabledPushCategorie.allCases, selectedPushStatuses ?? NotificationStatus.allCases)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isMovingToParent {
            setUpNavigationBar()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isBeingPresented && !isMovingToParent {
            self.setUpNavigationBar()
        }
    }
    
    private func setUpNavigationBar() {
        self.getNavigationBarBuilder("pl_alerts_title_notifications", #selector(didSelectBack)).setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }
    
    private func setUpMarkAsReadButton() {
        self.getNavigationBarBuilder("pl_alerts_title_notifications", #selector(didSelectBack)).setRightActions(.image(image: "markAsRead", action: #selector(markAsRead)))
            .build(on: self, with: nil)
    }
    
    private func setUpFilterButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showFilerVC))
        contentView.header.filters.isUserInteractionEnabled = true
        contentView.header.filters.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func showGeneralTooltip(_ sender: UIView) {
        let navigationToolTip = NavigationToolTip()
        navigationToolTip.add(title: localized("pl_alerts_title_tooltipAlerts"))
        navigationToolTip.add(description: localized("pl_alerts_text_tooltipAlerts"))
        navigationToolTip.show(in: self, from: sender)
        UIAccessibility.post(notification: .announcement, argument: localized("pl_alerts_text_tooltipAlerts").text)
    }
    
    private func addLoader(tableViewWidth: CGFloat) -> UIImageView {
        let spinner = UIImageView()
        spinner.setPointsLoader()
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableViewWidth, height: 16)
        return spinner
    }
    
    func getNavigationBarBuilder(_ titleStringKey: String, _ action: Selector) -> NavigationBarBuilder{
        return NavigationBarBuilder(
            style: .white,
            title: .tooltip(
                titleKey: titleStringKey,
                type: .red,
                action: { [weak self] sender in
                    self?.showGeneralTooltip(sender)
                }
            )
        )
    }
}

extension NotificationsInboxListViewController: NotificationsInboxListViewProtocol {
    
    func getNotificationsInboxListView() -> NotificationsInboxListView {
        return self.contentView
    }
}

private extension NotificationsInboxListViewController {
    
    @objc func didSelectBack() {
        presenter.backButtonSelected()
    }
    
    @objc private func markAsRead() {
        presenter.postPushSetAllStatus() { [weak self] in
            self?.lastPushId = nil
            self?.getData(self?.selectedPushCategories ?? EnabledPushCategorie.allCases, self?.selectedPushStatuses ?? NotificationStatus.allCases)
        }
    }
    
    @objc private func showFilerVC(){
        presenter.showFilterViewController(self.selectedPushCategories ?? [], self.selectedPushStatuses ?? [])
    }
    
    private func getData(_ pushFilters: [EnabledPushCategorie],_ pushStatuses: [NotificationStatus]) {
        let postPushListPageSizeDTO = PLPostPushListPageSizeUseCaseInput(categories: pushFilters, statuses: pushStatuses, pushId: nil)
        self.postPushListPageSize(postPushListPageSizeDTO)
        self.getUnreadedPushesCount(enabledPushCategories: pushFilters)
        self.presenter.getEnabledPushCategories(completion: nil)
    }
    
    func postPushListPageSize(_ postPushListPageSizeDTO: PLPostPushListPageSizeUseCaseInput) {
        self.presenter.postPushListPageSize(postPushListPageSizeDTO: postPushListPageSizeDTO, completion: { [weak self] response in
            self?.isLoadingNextPage = false
            if response == nil && self?.getNotificationsInboxListView().listState != .empty {
                TopAlertController.setup(TopAlertView.self).showAlert(localized("pl_topup_title_alert_error"), alertType: .failure, position: .top)
                self?.didSelectBack()
            }
            guard let id = response?.data.last?.id else { return }
            self?.lastPushId = id
        })
    }
    
    func getUnreadedPushesCount(enabledPushCategories: [EnabledPushCategorie]) {
        self.presenter.getUnreadedPushesCount(enabledPushCategories: enabledPushCategories) { [weak self] response in
            if let response = response, response.count > 0 {
                self?.setUpMarkAsReadButton()
            }
        }
    }
    
    func deleteNotification(_ indexPath: IndexPath) {
        presenter.didDeleteNotification(indexPath, { [weak self] success in
            if success {
                self?.getUnreadedPushesCount(enabledPushCategories: self?.selectedPushCategories ?? EnabledPushCategorie.allCases)
                TopAlertController.setup(TopAlertView.self).showAlert(localized("pl_alerts_text_messageDeleted"), alertType: .info, position: .bottom)
            } else {
                self?.getData(self?.selectedPushCategories ?? EnabledPushCategorie.allCases, self?.selectedPushStatuses ?? NotificationStatus.allCases)
            }
        })
    }
    
    func loadNextPage() {
        isLoadingNextPage = true
        let postPushListPageSizeDTO = PLPostPushListPageSizeUseCaseInput(categories: selectedPushCategories ?? EnabledPushCategorie.allCases, statuses: selectedPushStatuses ?? NotificationStatus.allCases, pushId: lastPushId)
        contentView.tableView.tableFooterView = addLoader(tableViewWidth: contentView.tableView.bounds.width)
        self.postPushListPageSize(postPushListPageSizeDTO)
    }
}

extension NotificationsInboxListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  self.presenter.sections[section].type == .info {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.isUserInteractionEnabled = false
        presenter.didSelectNotification(indexPath) {
            self.contentView.isUserInteractionEnabled = true
            self.getUnreadedPushesCount(enabledPushCategories: self.selectedPushCategories ?? EnabledPushCategorie.allCases)
        }
    }
}

extension NotificationsInboxListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.presenter.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.sections[section].list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.presenter.sections[indexPath.section]
        var returnedCell: UITableViewCell?
        switch section.type {
        case .push:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsInboxListCell.identifier) as? NotificationsInboxListCell
            if let model = section.list?[indexPath.row].notification {
                cell?.setWith(viewModel: NotificationsInboxListCellViewModel(title: model.title, sendTime: presenter.formatDate(date: model.sendTime) ?? "", enabledPushCategorie: model.category, status: model.status))
            }
            returnedCell = cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsInboxListInfoCell.identifier) as? NotificationsInboxListInfoCell
            let viewModel = NotificationsInboxInfoListCellViewModel(title: localized("pl_alerts_text_notificationsInfo"), message: localized("pl_alerts_link_setUpNotifications"))
            cell?.setWith(viewModel: viewModel)
            returnedCell = cell
        }
        
        return returnedCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.getHeaderView(section)
    }
    
    func getHeaderView(_ section: Int) -> UIView? {
        guard
            let section = self.presenter.sections[safe: section],
            let header = section.headerName
        else {
            return nil
        }
       
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        label.textColor = .lisboaGray
        label.font = .santander(family: .text, type: .bold, size: 20)
        label.text = header
        return view
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        for cell in tableView.visibleCells {
            if let index = tableView.indexPath(for: cell) {
                if index == indexPath {
                    self.fixDeleteView(cell, indexPath)
                    break
                }
            }
        }
    }
    
    func fixDeleteView(_ cell: UITableViewCell,_ indexPath: IndexPath) {
        let h = (cell.superview?.frame.height ?? 0) - 8
        let view = UIView(frame: CGRect(x: 16, y: 4, width: (cell.superview?.frame.width ?? 0) - 32 - 8, height: h))
        cell.superview?.subviews.first?.removeFromSuperview()
        cell.backgroundColor = .clear
        view.roundCorners(corners: [.bottomLeft,.topLeft], radius: 8)
        view.backgroundColor = .oneDarkTurquoise
        let trash = UIImageView(frame: CGRect(x: 24, y: h/2 - 24/2, width: 24, height: 24))
        trash.tag = indexPath.row
        trash.image = UIImage(named: "trash", in: .module, compatibleWith: nil)
        trash.isUserInteractionEnabled = true
        trash.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onDeleteRowClick(_:))))
        view.addSubview(trash)
        cell.superview?.insertSubview(view, at: 0)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            self.deleteNotification(indexPath)
            completion(true)
        }
        deleteAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    @objc func onDeleteRowClick(_ gesture: UIGestureRecognizer){
        if let cell = gesture.view?.superview?.superview?.subviews[1] as? NotificationsInboxListCell{
            guard let indexPath = self.contentView.tableView.indexPath(for: cell) else {
                return
            }
            self.deleteNotification(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let countOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row >= Int(countOfRowsInSection/2) && !isLoadingNextPage {
            loadNextPage()
        }
    }
}

extension NotificationsInboxListViewController: NotificationsInboxListViewControllerDelegate {
    func refreshDataWithFilters(_ categories: [EnabledPushCategorie],_ statuses: [NotificationStatus]) {
        self.selectedPushCategories = categories
        self.selectedPushStatuses = statuses
        self.contentView.header.updateFilterButton(selectedFilterCount: categories.count + statuses.count)
        self.presenter.sections.removeAll()
        getData(categories.isEmpty ? EnabledPushCategorie.allCases : categories, statuses.isEmpty ? NotificationStatus.allCases : statuses)
        getUnreadedPushesCount(enabledPushCategories: categories)
    }
}
