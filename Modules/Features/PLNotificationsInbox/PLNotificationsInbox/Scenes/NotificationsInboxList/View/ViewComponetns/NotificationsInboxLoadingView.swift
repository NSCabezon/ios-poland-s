//
//  NotificationsInboxLoadingView.swift
//  PLNotificationsInbox
//
//  Created by 185998 on 25/01/2022.
//

import Foundation
import UI
import CoreFoundationLib

class NotificationsInboxLoadingView: UIView {
    private let loader = UIImageView()
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
        addSubview(loader)
    }

    private func setUpView() {
        setUpImage()
    }

    private func setUpImage() {
        loader.backgroundColor = .white
        loader.contentMode = .scaleAspectFit
        loader.setPointsLoader()
    }

    private func setUpLayouts() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 0),
            loader.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 0),
            loader.widthAnchor.constraint(equalToConstant: 120),
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            loader.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
