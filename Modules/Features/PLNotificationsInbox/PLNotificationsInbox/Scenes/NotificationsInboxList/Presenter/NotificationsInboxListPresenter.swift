//
//  NotificationsInboxListPresenter.swift
//  NotificationsInbox
//
//  Created by 186484 on 10/09/2021.
//

import UI
import CoreFoundationLib
import SANPLLibrary
import PLNotifications
import PLCommons

protocol NotificationsInboxListPresenterProtocol: MenuTextWrapperProtocol, PLNotificationsUseCaseManagerProtocol {
    var view: NotificationsInboxListViewProtocol? { get set }
    var sections: [NotificationsInboxListViewSectionViewModel] { get set }
    func backButtonSelected()
    func showFilterViewController(_ filters: [EnabledPushCategorie],_ statuses: [NotificationStatus])
    func didSelectNotification(_ indexPath: IndexPath, _ onRefreshData: @escaping () -> Void)
    func didDeleteNotification(_ indexPath: IndexPath, _ onRefreshData: @escaping (Bool) -> Void)
    func formatDate(date: String) -> String?
}

final class NotificationsInboxListPresenter {
    var sections = [NotificationsInboxListViewSectionViewModel]()
    weak var view: NotificationsInboxListViewProtocol?
    let dependenciesResolver: DependenciesResolver
    let dateFormatter = PLTimeFormat.ddMMyyyyDash.createDateFormatter()
    let dateFormatterForSendTime = PLTimeFormat.ddMMyyyy_HHmmDotted.createDateFormatter()
    private lazy var notificationsUseCaseManager: PLNotificationsUseCaseManagerProtocol? = {
        return self.dependenciesResolver.resolve(forOptionalType: PLNotificationsUseCaseManagerProtocol.self)
    }()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension NotificationsInboxListPresenter {
    var coordinator: NotificationsInboxListCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: NotificationsInboxListCoordinatorProtocol.self)
    }
}

extension NotificationsInboxListPresenter: NotificationsInboxListPresenterProtocol {
    func getPushBeforeLogin(pushId: Int, loginId: Int, completion: @escaping (PLNotificationEntity?) -> Void) {}
    
    func backButtonSelected() {
        coordinator.goBack()
    }
    
    func showFilterViewController(_ filters: [EnabledPushCategorie], _ statuses: [NotificationStatus]) {
        coordinator.showFilterViewController(filters, statuses)
    }
    
    func didSelectNotification(_ indexPath: IndexPath, _ onRefreshData: @escaping() -> Void) {
        guard
            let notification = self.sections[indexPath.section].list?[indexPath.row],
            let id = notification.notification.id
        else {
            return
        }
        getPushById(pushId: id) { [weak self] response in
            guard let self = self, let response = response, let id = response.id else { return }
            let customPushLaunch = CustomPushLaunchActionTypeInfo(messageId: id, content: response.content)
            self.customPushNotificationCoordinator.start(actionType: customPushLaunch)
        }
        let pushList = [PLPushStatus(id: id, status: NotificationStatus.read.rawValue)]
        let pushStatus = PLPushStatusUseCaseInput(pushList: pushList, loginId: nil)
        self.postPushStatus(pushStatus: pushStatus) { status in
            self.sections[indexPath.section].list?[indexPath.row].notification.status = .read
            self.view?.getNotificationsInboxListView().tableView.reloadRows(at: [indexPath], with: .none)
            onRefreshData()
        }
    }
    
    func didDeleteNotification(_ indexPath: IndexPath, _ onRefreshData: @escaping (Bool) -> Void) {
        guard
            let notification = self.sections[indexPath.section].list?[indexPath.row],
            let id = notification.notification.id
        else {
            return
        }
        let pushList = [PLPushStatus(id: id, status: NotificationStatus.deleted.rawValue)]
        let pushStatus = PLPushStatusUseCaseInput(pushList: pushList, loginId: nil)
        self.postPushStatus(pushStatus: pushStatus) { response in
            let isSuccess = response != nil
            if isSuccess {
                self.sections[indexPath.section].list?.remove(at: indexPath.row)
                self.view?.getNotificationsInboxListView().tableView.performBatchUpdates {
                    self.view?.getNotificationsInboxListView().tableView.deleteRows(at: [indexPath], with: .automatic)
                } completion: { completion in }
            }
            onRefreshData(isSuccess)
        }
    }
}

extension NotificationsInboxListPresenter {
    func postPushListPageSize(postPushListPageSizeDTO: PLPostPushListPageSizeUseCaseInput, completion: @escaping (PLNotificationListEntity?) -> Void) {
        notificationsUseCaseManager?.postPushListPageSize(postPushListPageSizeDTO: postPushListPageSizeDTO, completion: { response in
            self.view?.getNotificationsInboxListView().tableView.tableFooterView = nil
            self.updatePushList(response, true)
            completion(response)
        })
    }
    
    func postPushStatus(pushStatus: PLPushStatusUseCaseInput, completion: @escaping (PLPushStatusResponseEntity?) -> Void) {
        notificationsUseCaseManager?.postPushStatus(pushStatus: pushStatus, completion: completion)
    }
    
    func postPushStatusBeforeLogin(pushStatus: PLPushStatusUseCaseInput, completion: @escaping (PLPushStatusResponseEntity?) -> Void) {
        notificationsUseCaseManager?.postPushStatusBeforeLogin(pushStatus: pushStatus, completion: completion)
    }
    
    func getPushById(pushId: Int, completion: @escaping (PLNotificationEntity?) -> Void) {
        notificationsUseCaseManager?.getPushById(pushId: pushId, completion: completion)
    }
    
    func getList(completion: @escaping (PLNotificationListEntity?) -> Void) {
        notificationsUseCaseManager?.getList(completion: completion)
    }
    
    func getUnreadedPushesCount(enabledPushCategories: [EnabledPushCategorie], completion: @escaping (PLUnreadedPushCountEntity?) -> Void) {
        notificationsUseCaseManager?.getUnreadedPushesCount(enabledPushCategories: enabledPushCategories, completion: { response in
            if let response = response {
                self.view?.getNotificationsInboxListView().header.updateUnreadedMessagesLabel(unreadedMessagesCount: response.count)
                
            } else {
                self.view?.getNotificationsInboxListView().header.updateUnreadedMessagesLabel(unreadedMessagesCount: nil)
            }
            completion(response)
        })
    }
    
    func getEnabledPushCategories(completion: ((PLEnabledPushCategoriesListEntity?) -> Void)?) {
        notificationsUseCaseManager?.getEnabledPushCategories(completion: { response in
            if let response = response {
                var state: NotificationsInboxCategoryStatus = .enableAll
                if response.enabledCategories.isEmpty {
                    state = .disableAll
                } else if !response.enabledCategories.contains(.alert) {
                    state = .disableAlerts
                } else if !response.enabledCategories.contains(.notice) {
                    state = .disableNotice
                } else {
                    state = .enableAll
                }
                self.view?.getNotificationsInboxListView().categoryState = state
                completion?(response)
            }
        })
    }
    
    func postPushSetAllStatus(completion: @escaping () -> Void) {        
        notificationsUseCaseManager?.postPushSetAllStatus( completion: {
            self.sections.removeAll()
            completion()
        })
    }
    
    public func updatePushList(_ response: PLNotificationListEntity?, _ newData: Bool = false) {
        let todayHeader = "\(localized("pl_alerts_text_today"))"
        let yestardayHeader = "\(localized("pl_alerts_text_yestarday"))"
        let result = sort(pushList: response)
        let pushDictionary = result.0
        let sortedKeys = result.1
        
        if sections.isEmpty {
            for key in sortedKeys {
                let section = NotificationsInboxListViewSectionViewModel(type: .push, list: pushDictionary[key] ?? [], headerName: key)
                self.sections.append(section)
            }
            self.view?.getNotificationsInboxListView().tableView.reloadData()
            self.view?.getNotificationsInboxListView().listState = (response?.data ?? []).count == 0 ? .empty : .hasNotifications
            return
        }
        
        self.view?.getNotificationsInboxListView().tableView.performBatchUpdates({
            for key in sortedKeys {
                if let index = self.sections.firstIndex(where: { $0.headerName == todayHeader }) {
                    setSection(index, key, pushDictionary)
                }
                
                if let index = self.sections.firstIndex(where: { $0.headerName == yestardayHeader}) {
                    setSection(index, key, pushDictionary)
                }
                
                if let index = self.sections.firstIndex(where: { $0.headerName == key }) {
                    setSection(index, key, pushDictionary)
                } else {
                    let section = NotificationsInboxListViewSectionViewModel(type: .push, list: pushDictionary[key] ?? [], headerName: key)
                    self.sections.append(section)
                    print(sections.count)
                    var indexPaths: [IndexPath] = []
                    for i in 0 ..< pushDictionary[key]!.count - 1 {
                        indexPaths.append(IndexPath(row: i, section: sections.count - 1))
                    }
                    self.view?.getNotificationsInboxListView().tableView.insertSections(IndexSet(integer: sections.count - 1), with: .automatic)
                    self.view?.getNotificationsInboxListView().tableView.insertRows(at:indexPaths, with: .automatic)
                }
            }
        }, completion: nil)
    }
    
    func setSection(_ index: Int,_ key: String,_ dictionary: [String: [PLNotificationListSectionViewModel]] ){
        if self.sections.count <= index {
            return
        }
        let old = self.sections[index].list
        self.sections[index].list?.append(contentsOf: dictionary[key] ?? [])
        var indexPaths: [IndexPath] = []
        let lastIndex = ((old?.count ?? 0) - 1)
        
        for i in lastIndex..<(lastIndex+dictionary[key]!.count) {
            indexPaths.append(IndexPath(row: i, section: index))
        }
        self.view?.getNotificationsInboxListView().tableView.insertRows(at:indexPaths, with: .automatic)
    }
    
    public func formatDate(date: String) -> String? {
        guard let dateObj = PLTimeFormat.YYYYMMDD_HHmmssSSSZ.createDateFormatter().date(from: date) else { return nil}
        return dateFormatterForSendTime.string(from: dateObj)
    }
    
    public func sectionTitleFor(date: Date) -> String? {
        return self.dateFormatter.string(from: date)
    }
    
    public func sectionTitleFor(date: String) -> String? {
        guard let dateObj = PLTimeFormat.YYYYMMDD_HHmmssSSSZ.createDateFormatter().date(from: date) else { return nil}
        return self.dateFormatter.string(from: dateObj)
    }
    
    private func sort(pushList: PLNotificationListEntity?) -> ([String: [PLNotificationListSectionViewModel]], [String])  {
        let array = pushList?.data.map({ notification -> PLNotificationListSectionViewModel in
            return PLNotificationListSectionViewModel(notification: notification, sendTitleDate: sectionTitleFor(date: notification.sendTime) ?? "")
        })
        
        let groupedByDay = Dictionary(grouping: array ?? [], by: { $0.sendTitleDate })
        var sortedDictionay: [String: [PLNotificationListSectionViewModel]] = [:]
        let todayHeader = "\(localized("pl_alerts_text_today"))"
        let yestardayHeader = "\(localized("pl_alerts_text_yestarday"))"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy"
        var sortedKeys = groupedByDay.keys.sorted {
            guard
                let d1 = dateFormat.date(from: $0),
                let d2 = dateFormat.date(from: $1)
            else {
                return false
            }
            return d1 > d2
        }
        
        groupedByDay.forEach { key, value in
            if key == sectionTitleFor(date: Date()) {
                sortedDictionay.updateValue(value, forKey: todayHeader)
                if let index = sortedKeys.firstIndex(where: { k in
                    k == key
                }) {
                    sortedKeys[index] = todayHeader
                }
            } else if key == sectionTitleFor(date: Date().dayBefore) {
                sortedDictionay.updateValue(value, forKey: yestardayHeader)
                if let index = sortedKeys.firstIndex(where: { k in
                    k == key
                }) {
                    sortedKeys[index] = yestardayHeader
                }
            } else {
                sortedDictionay.updateValue(value, forKey: key)
            }
        }
        return (sortedDictionay, sortedKeys)
    }
}

private extension NotificationsInboxListPresenter {
    var customPushNotificationCoordinator: CustomPushNotificationCoordinator {
        dependenciesResolver.resolve(for: CustomPushNotificationCoordinator.self)
    }
}
