//
//  NotificationsInboxFilterHeaderView.swift
//  PLNotificationsInbox
//
//  Created by 185860 on 29/12/2021.
//

import Foundation
import UIOneComponents
import CoreFoundationLib

class NotificationsInboxFilterHeaderView: UIView {
    private let topSeparator = UIView()
    private let bottomSeparator = UIView()
    private let unreadedMessagesLabel = UILabel()
    private let loader = UIImageView()
    let filters = UIButton()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUnreadedMessagesLabel(unreadedMessagesCount: Int?) {
        if let unreadedMessagesCount = unreadedMessagesCount {
            unreadedMessagesLabel.text = "\(localized("pl_alerts_text_unreadCheckBox")) (\(unreadedMessagesCount))"
        } else {
            unreadedMessagesLabel.text = "-"
        }
        loader.removeLoader()
    }
    
    func updateFilterButton(selectedFilterCount: Int) {
        let attributesNormal: [NSAttributedString.Key: Any] = [.font: UIFont.santander(family: .text, type: .semibold, size: 14)]
        let attributedText = NSMutableAttributedString(string: localized("pl_alerts_link_filters"), attributes: attributesNormal)
        if selectedFilterCount > 0 {
            let attributesBold: [NSAttributedString.Key: Any] = [.font: UIFont.santander(family: .text, type: .bold, size: 14)]
            attributedText.append(NSMutableAttributedString(string: " (\(selectedFilterCount))", attributes: attributesBold))
        }
        filters.setAttributedTitle(attributedText, for: .normal)
    }
    
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpView() {
        loader.setPointsLoader()
        unreadedMessagesLabel.textColor = .lisboaGray
        unreadedMessagesLabel.font = .santander(
            family: .micro,
            type: .semibold,
            size: 14
        )
        
        filters.setImage(UIImage(named: "filterSymbol", in: .module, compatibleWith: nil), for: .normal)
        filters.setTitle(localized("pl_alerts_link_filters"), for: .normal)
        filters.setTitleColor(.oneDarkTurquoise, for: .normal)
        filters.titleLabel?.font = .santander(
            family: .text,
            type: .semibold,
            size: 14)
        filters.semanticContentAttribute = .forceRightToLeft
        filters.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        let lightGray = UIColor(red: 218.0 / 255.0, green: 220.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
        topSeparator.backgroundColor = lightGray
        bottomSeparator.backgroundColor = lightGray
    }
    
    private func setUpSubviews() {
        addSubview(unreadedMessagesLabel)
        addSubview(loader)
        addSubview(filters)
        addSubview(topSeparator)
        addSubview(bottomSeparator)
    }
    
    private func setUpLayouts() {
        unreadedMessagesLabel.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false
        filters.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unreadedMessagesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            unreadedMessagesLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            loader.heightAnchor.constraint(equalToConstant: 16),
            loader.widthAnchor.constraint(equalToConstant: 88),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            filters.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            filters.centerYAnchor.constraint(equalTo: centerYAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSeparator.topAnchor.constraint(equalTo: topAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
