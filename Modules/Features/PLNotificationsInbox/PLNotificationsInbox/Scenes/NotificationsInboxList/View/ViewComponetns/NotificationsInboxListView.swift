//
//  NotificationsInboxListView.swift
//  NotificationsInbox
//

import UI
import PLUI
import UIKit
import SANPLLibrary
import CoreFoundationLib


enum NotificationsInboxListStatus {
    case loading
    case empty
    case hasNotifications
}

enum NotificationsInboxCategoryStatus {
    case enableAll
    case disableAll
    case disableAlerts
    case disbleDisableNotice
}

final class NotificationsInboxListView: UIView {
    var listState: NotificationsInboxListStatus = .loading {
        didSet{
            reloadView()
        }
    }
    
    var categoryState: NotificationsInboxCategoryStatus = .enableAll {
        didSet{
            reloadView()
        }
    }
    
    let header = NotificationsInboxFilterHeaderView()
    let emptyView = NotificationsInboxEmptyView()
    let loadingView = NotificationsInboxLoadingView()
    
    let infoView = NotificationsInboxInfoView()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .white
        setUpSubviews()
        loadingView.isHidden = true
        emptyView.isHidden = true
    }
    
    private func reloadView() {
        loadingView.isHidden = true
        emptyView.isHidden = true
        self.tableView.tableHeaderView = nil
        switch listState{
        case .loading:
            loadingView.isHidden = false
        case .empty:
            emptyView.isHidden = false
        case .hasNotifications:
            break
        }
        
        switch categoryState{
        case .enableAll:
            self.tableView.tableHeaderView = nil
        case .disableAll:
            infoView.fill(
                notificationsInfo: localized("pl_alerts_text_notificationsInfo"),
                setUpNotifications: localized("pl_alerts_link_setUpNotifications")
            )
            self.tableView.tableHeaderView = infoView
        case .disableAlerts:
            infoView.fill(
                notificationsInfo: localized("pl_alerts_text_turnOnAlertsExpl"),
                setUpNotifications: localized("pl_alerts_link_turnOnAlerts")
            )
            self.tableView.tableHeaderView = infoView
        case .disbleDisableNotice:
            infoView.fill(
                notificationsInfo: localized("pl_alerts_text_turnOnInfoNotExpl"),
                setUpNotifications: localized("pl_alerts_link_turnOnAlerts")
            )
            self.tableView.tableHeaderView = infoView
        }
        setUpTableViewWithInfoViewLayout()
    }
    
    private func setUpSubviews() {
        addSubview(header)
        setUpHeaderLayout()
        
        addSubview(tableView)
        setUpTableViewLayout()
        self.tableView.tableHeaderView = nil
        
        addSubview(loadingView)
        setUpLoadingViewLayout()
        
        addSubview(emptyView)
        setUpEmptyViewLayout()
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(NotificationsInboxListCell.self, forCellReuseIdentifier: NotificationsInboxListCell.identifier)
        tableView.register(NotificationsInboxListInfoCell.self, forCellReuseIdentifier: NotificationsInboxListInfoCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
    }
    
    private func setUpHeaderLayout() {
        header.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setUpEmptyViewLayout() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.topAnchor.constraint(equalTo: header.bottomAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 211)
        ])
    }
    
    private func setUpLoadingViewLayout() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.topAnchor.constraint(equalTo: header.bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 211)
        ])
    }
    
    private func setUpTableViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setUpTableViewWithInfoViewLayout() {
        if infoView.superview == nil {
            return
        }
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        updateInfoViewHeight()
    }
    
    func updateInfoViewHeight() {
        infoView.setNeedsLayout()
        infoView.layoutIfNeeded()
        
        let height = infoView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        NSLayoutConstraint.activate([
            infoView.heightAnchor.constraint(equalToConstant: height)
        ])        
    }
}
