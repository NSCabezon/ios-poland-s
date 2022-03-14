//
//  NotificationsInboxEmptyView.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 30/12/2021.
//

import Foundation
import UI
import CoreFoundationLib
import PLUI

class NotificationsInboxEmptyView: UIView {
    private let containerView = UIView()
    private let image = UIImageView()
    private let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpSubviews() {
        addSubview(containerView)
        containerView.addSubview(image)
        containerView.addSubview(label)
    }
    
    private func setUpView() {
        setUpLabel()
        setUpImage()
    }
    
    private func setUpLabel() {
        label.text = localized("pl_alerts_text_noAlerts")
        label.textColor = .lisboaGray
        label.font = .santander(
            family: .micro,
            type: .regular,
            size: 16
        )        
        label.textAlignment = .center
    }
    
    private func setUpImage() {
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFit
        image.image = PLAssets.image(named: "leavesEmpty")
    }
    
    private func setUpLayouts() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: 211)
        ])

        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            image.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            image.heightAnchor.constraint(equalToConstant: 211)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: image.topAnchor, constant: 89)
        ])
    }
}
