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
    case disableNotice
}

final class NotificationsInboxListView: UIView {
    var listState: NotificationsInboxListStatus = .loading {
        didSet {
            reloadView()
        }
    }
    
    var categoryState: NotificationsInboxCategoryStatus = .enableAll {
        didSet {
            reloadView()
        }
    }
    
    let header = NotificationsInboxFilterHeaderView()
    let emptyView = NotificationsInboxEmptyView()
    let loadingView = NotificationsInboxLoadingView()
    
    let infoView = NotificationsInboxInfoView()
    let tableView = UITableView(frame: .zero, style: .grouped)
    
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
    }
    
    private func reloadView() {
        loadingView.isHidden = true
        self.tableView.tableHeaderView = nil
        self.tableView.tableFooterView = nil

        switch listState {
        case .loading:
            loadingView.isHidden = false
        case .empty:
            self.tableView.tableFooterView = categoryState == .disableAll ? nil : emptyView
        case .hasNotifications:
            break
        }
        
        switch categoryState {
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
        case .disableNotice:
            infoView.fill(
                notificationsInfo: localized("pl_alerts_text_turnOnInfoNotExpl"),
                setUpNotifications: localized("pl_alerts_link_turnOnAlerts")
            )
            self.tableView.tableHeaderView = infoView
        }
        setUpTableViewWithInfoViewLayout()
        setUpTableViewWithEmptyViewLayout()
    }
    
    private func setUpSubviews() {
        addSubview(header)
        setUpHeaderLayout()
        
        addSubview(tableView)
        setUpTableViewLayout()
        self.tableView.tableHeaderView = nil
        self.tableView.tableFooterView = nil

        addSubview(loadingView)
        setUpLoadingViewLayout()
                
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(NotificationsInboxListCell.self, forCellReuseIdentifier: NotificationsInboxListCell.identifier)
        tableView.register(NotificationsInboxListInfoCell.self, forCellReuseIdentifier: NotificationsInboxListInfoCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
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
    
    private func setUpTableViewWithEmptyViewLayout() {
        if emptyView.superview == nil {
            return
        }
        
        emptyView.translatesAutoresizingMaskIntoConstraints = true
        emptyView.frame = CGRect(x: 0, y: emptyView.frame.origin.y, width: self.tableView.frame.width, height: 211)
    }
    
    func updateInfoViewHeight() {
        infoView.setNeedsLayout()
        infoView.layoutIfNeeded()
        
        let height = infoView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        infoView.translatesAutoresizingMaskIntoConstraints = true
        infoView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: height)
        self.tableView.reloadData()
    }
}
