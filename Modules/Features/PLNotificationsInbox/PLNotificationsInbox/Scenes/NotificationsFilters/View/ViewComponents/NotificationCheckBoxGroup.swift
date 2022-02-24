//
//  NotificationCheckBoxGroup.swift
//  PLNotificationsInbox
//
//  Created by 188418 on 26/01/2022.
//

import UIKit
import PLUI

protocol NotificationsCheckboxGroupDelegate {
    func didSelect(checkbox: GlobileCheckBox)
    func didDeselect(checkbox: GlobileCheckBox)
}

class NotificationCheckBoxGroup: UIView {
    
    var delegate: NotificationsCheckboxGroupDelegate?
    var checkboxes: [UIView]
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18.0
        stackView.distribution = .fill
        return stackView
    }()
    
    init(checkboxes: [UIView]) {
        self.checkboxes = checkboxes
        super.init(frame: .zero)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func addSubviews() {
        addSubview(stackView)
        checkboxes.forEach { self.stackView.addArrangedSubview($0) }
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: stackView.topAnchor),
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    
    private func setupViews() {
        checkboxes.forEach { checkbox in
            if let checkbox = checkbox as? GlobileCheckBox {
                checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .valueChanged)
            }
        }
    }
    
    @objc func checkboxTapped(_ sender: GlobileCheckBox) {
        if sender.isSelected {
            delegate?.didSelect(checkbox: sender)
        } else {
            delegate?.didDeselect(checkbox: sender)
        }
    }
}

