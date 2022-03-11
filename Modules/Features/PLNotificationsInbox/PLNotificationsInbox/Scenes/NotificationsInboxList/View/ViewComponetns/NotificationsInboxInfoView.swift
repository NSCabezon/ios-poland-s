//
//  NotificationsInboxInfoView.swift
//  PLNotificationsInbox
//
//  Created by 185998 on 30/12/2021.
//

import Foundation
import UI
import CoreFoundationLib
import UIKit

class NotificationsInboxInfoView: UIView {
    private let backgroundView = UIView()
    private let notificationsInfoLabel = UILabel()
    private let setUpNotificationsLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fill(notificationsInfo: String, setUpNotifications: String){
        notificationsInfoLabel.text = notificationsInfo
        setUpNotificationsLabel.text = setUpNotifications
    }

    private func setUp() {
        setUpViews()
        setUpSubviews()
        setUpLayouts()
    }

    private func setUpSubviews() {
        backgroundView.addSubview(notificationsInfoLabel)
        backgroundView.addSubview(setUpNotificationsLabel)
        addSubview(backgroundView)
    }

    private func setUpViews() {
        setUpBackgroundView()
        setUpNotificationsInfoLabel()
        setUpSetUpNotificationsLabel()
    }

    private func setUpBackgroundView() {
        backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 249.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    }

    private func setUpNotificationsInfoLabel() {
        notificationsInfoLabel.numberOfLines = 0
        notificationsInfoLabel.lineBreakMode = .byWordWrapping
        notificationsInfoLabel.textColor = .lisboaGray
        notificationsInfoLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        notificationsInfoLabel.textAlignment = .left
    }

    private func setUpSetUpNotificationsLabel() {
        setUpNotificationsLabel.numberOfLines = 0
        setUpNotificationsLabel.lineBreakMode = .byWordWrapping
        setUpNotificationsLabel.textColor = .darkTorquoise
        setUpNotificationsLabel.font = .santander(
            family: .micro,
            type: .bold,
            size: 14
        )
        setUpNotificationsLabel.textAlignment = .left
    }

    private func setUpLayouts() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])

        notificationsInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notificationsInfoLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            notificationsInfoLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            notificationsInfoLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16)
        ])

        setUpNotificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setUpNotificationsLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            setUpNotificationsLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            setUpNotificationsLabel.topAnchor.constraint(equalTo: notificationsInfoLabel.bottomAnchor, constant: 16),
            setUpNotificationsLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16)
        ])
    }
}
