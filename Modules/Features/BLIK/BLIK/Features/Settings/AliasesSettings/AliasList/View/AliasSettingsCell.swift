//
//  AliasSettingsCell.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 01/09/2021.
//

import UI

final class AliasSettingsCell: UITableViewCell {
    static let identifier: String = "BLIK.AliasSettingsCell"
    private let name = UILabel()
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
    
    func setAliasName(_ name: String) {
        self.name.text = name
    }
    
    private func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    private func configureSubviews() {
        [name, image, separator].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            name.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -18),
            name.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -17),
            
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            image.heightAnchor.constraint(equalToConstant: 24),
            image.widthAnchor.constraint(equalToConstant: 24),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureStyling() {
        separator.backgroundColor = .mediumSkyGray
        image.image = Images.chevron
        name.numberOfLines = 0
        name.textColor = .lisboaGray
        name.font = .santander(
            family: .micro,
            type: .bold,
            size: 18
        )
    }
}
