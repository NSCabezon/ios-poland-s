//
//  ContactTableViewCell.swift
//  PhoneTopUp
//
//  Created by 188216 on 22/12/2021.
//

import UIKit
import UI
import PLUI

final class ContactTableViewCell: UITableViewCell {
    // MARK: Identifier
    
    static let identifier = String(describing: ContactTableViewCell.self)
    
    // MARK: Views
    
    private let borderView = UIView()
    private let contentStackView = UIStackView()
    private let labelStackView = UIStackView()
    private let nameLabel = UILabel()
    private let numberLabel = UILabel()
    private let initialsContainer = UIView()
    private let initialsLabel = UILabel()
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        initialsContainer.layer.cornerRadius = initialsContainer.frame.size.width / 2.0
        initialsContainer.layer.masksToBounds = true
    }
    
    // MARK: Configuration
    
    func configure(with contact: MobileContact) {
        nameLabel.text = contact.fullName
        numberLabel.text = contact.phoneNumber
        initialsLabel.text = contact.initials
        initialsContainer.backgroundColor = contact.color
    }
    
    private func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(borderView, padding: UIEdgeInsets(top: 0, left: 0, bottom: 16.0, right: 0))
        borderView.addSubviewConstraintToEdges(contentStackView)
        
        contentStackView.addArrangedSubview(initialsContainer)
        contentStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(numberLabel)
        
        initialsContainer.addSubview(initialsLabel)
    }
    
    private func prepareStyles() {
        selectionStyle = .none
        
        borderView.drawBorder(cornerRadius: 4.0, color: .mediumSkyGray, width: 1)
        
        nameLabel.font = .santander(family: .micro, type: .bold, size: 16.0)
        nameLabel.textColor = .lisboaGray
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        numberLabel.font = .santander(family: .micro, type: .regular, size: 14.0)
        numberLabel.textColor = .lisboaGray
        numberLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        numberLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        initialsLabel.font = .santander(family: .headline, type: .bold, size: 16.0)
        initialsLabel.textColor = .white
    }
    
    private func setUpLayout() {
        contentStackView.axis = .horizontal
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        contentStackView.spacing = 8.0
        
        labelStackView.axis = .vertical
        
        initialsContainer.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            initialsContainer.widthAnchor.constraint(equalTo: initialsContainer.heightAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: initialsContainer.centerYAnchor),
            initialsLabel.centerXAnchor.constraint(equalTo: initialsContainer.centerXAnchor),
        ])
    }
}
