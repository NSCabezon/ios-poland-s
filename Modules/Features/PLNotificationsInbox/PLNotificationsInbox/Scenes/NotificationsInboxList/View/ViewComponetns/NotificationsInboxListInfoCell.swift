//
//  NotificationsInboxListInfoCell.swift
//  PLNotificationsInbox
//
//  Created by 188418 on 11/01/2022.
//

import Foundation

final class NotificationsInboxListInfoCell: UITableViewCell {
    static public let identifier: String = "NotificationsInboxListInfoCell"
    var info = NotificationsInboxInfoView()
    

    // MARK: - Initialisation
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
}

private extension NotificationsInboxListInfoCell {
    // MARK: - Private methods
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpView() {
        selectionStyle = .none
    }
    
    private func setUpSubviews() {
        contentView.addSubview(info)
    }
    
    private func setUpLayouts() {
        info.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            info.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            info.topAnchor.constraint(equalTo: contentView.topAnchor),
            info.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            info.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension NotificationsInboxListInfoCell: NotificationInfoViewModelSetUpable {
    func setWith(viewModel: NotificationsInboxInfoListCellViewModel) {
        self.info.fill(notificationsInfo: viewModel.title, setUpNotifications: viewModel.message)
    }
}
