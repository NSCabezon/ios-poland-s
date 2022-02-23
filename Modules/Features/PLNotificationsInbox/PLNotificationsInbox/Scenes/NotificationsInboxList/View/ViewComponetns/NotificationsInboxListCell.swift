//
//  NotificationsInboxListCell.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 29/12/2021.
//

import Foundation

final class NotificationsInboxListCell: UITableViewCell {
    static public let identifier: String = "NotificationsInboxListCell"

    lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .lisboaGray
        return label
    }()

    lazy var dataLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .brownishGray
        return label
    }()

    lazy var icon = { () -> UIImageView in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let containerView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.mediumSkyGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    let seperator = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor.mediumSkyGray
        return view
    }()

    lazy var iconArrow = { () -> UIImageView in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "rightArrow", in: .module, compatibleWith: nil)
        return imageView
    }()

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

private extension NotificationsInboxListCell {
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
        contentView.addSubview(containerView)
        containerView.addSubview(icon)
        containerView.addSubview(seperator)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dataLabel)
        containerView.addSubview(iconArrow)
    }
    
    private func setUpLayouts() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])

        icon.translatesAutoresizingMaskIntoConstraints = false
        seperator.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        iconArrow.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            seperator.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            seperator.widthAnchor.constraint(equalToConstant: 1),
            seperator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            seperator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: seperator.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: iconArrow.leadingAnchor, constant: 8),

            dataLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dataLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            dataLabel.trailingAnchor.constraint(equalTo: iconArrow.leadingAnchor, constant: 8),
            dataLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            iconArrow.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            iconArrow.widthAnchor.constraint(equalToConstant: 24),
            iconArrow.heightAnchor.constraint(equalToConstant: 24),
            iconArrow.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}

extension NotificationsInboxListCell: NotificationViewModelSetUpable {
    func setWith(viewModel: NotificationsInboxListCellViewModel) {
        if viewModel.isUnreadedMessage {
            titleLabel.font = .santander(family: .text, type: .bold, size: 14)
            dataLabel.font = .santander(family: .text, type: .bold, size: 12)
        } else {
            titleLabel.font = .santander(family: .text, type: .regular, size: 14)
            dataLabel.font = .santander(family: .text, type: .regular, size: 12)
        }
        
        titleLabel.text = viewModel.title
        dataLabel.text = viewModel.sendTime
        icon.image = viewModel.iconImage
    }
}
