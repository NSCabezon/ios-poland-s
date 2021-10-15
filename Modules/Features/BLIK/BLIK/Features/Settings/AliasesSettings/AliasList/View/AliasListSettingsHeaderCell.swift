//
//  AliasListSettingsHeaderCell.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 01/09/2021.
//

import UI

final class AliasListSettingsHeaderCell: UITableViewCell {
    static let identifier: String = "BLIK.AliasListSettingsHeaderCell"
    private let message = UILabel()
    private let image = UIImageView()
    private let separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setHeaderMessage(_ message: String) {
        self.message.text = message
    }
    
    private func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    private func configureSubviews() {
        [message, image, separator].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            message.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            message.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            message.bottomAnchor.constraint(lessThanOrEqualTo: separator.topAnchor, constant: -17),
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            image.heightAnchor.constraint(equalToConstant: 55),
            image.widthAnchor.constraint(equalToConstant: 55),
            image.bottomAnchor.constraint(lessThanOrEqualTo: separator.topAnchor, constant: -17),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureStyling() {
        separator.backgroundColor = .mediumSkyGray
        image.image = Images.Settings.securityLock
        message.numberOfLines = 0
        message.textColor = .lisboaGray
        message.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
    }
}

