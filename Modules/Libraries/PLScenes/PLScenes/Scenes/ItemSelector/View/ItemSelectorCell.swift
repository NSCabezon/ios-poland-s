//
//  ItemSelectorCell.swift
//  PLScenes
//
//  Created by 185167 on 04/02/2022.
//

import UI
import PLUI

final class ItemSelectorCell: UITableViewCell {
    public static let identifier = String(describing: self)
    
    private let container = TappableControl()
    private let titleLabel = UILabel()
    private let checkImageView = UIImageView(image: PLAssets.image(named: "checkIcon"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(
        title: String,
        isSelected: Bool,
        onTap: @escaping () -> ()
    ) {
        titleLabel.text = title
        configureStyling(isSelected: isSelected)
        container.onTap = onTap
    }
    
    private func setUp() {
        configureStyling()
        configureSubview()
        configureSelectionStyle()
    }
    
    private func configureSelectionStyle() {
        selectionStyle = .none
        isUserInteractionEnabled = true
    }
    
    private func configureSubview() {
        contentView.addSubview(container)
        
        [titleLabel, checkImageView].forEach {
            container.addSubview($0)
        }
        
        [container, titleLabel, checkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            checkImageView.centerXAnchor.constraint(equalTo: container.trailingAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: container.topAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 17),
            checkImageView.heightAnchor.constraint(equalToConstant: 17)
        ])
    }
    
    private func configureStyling() {
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.font = .santander(family: .micro, type: .bold, size: 14)
    }
    
    private func configureStyling(isSelected: Bool) {
        checkImageView.isHidden = !isSelected
        
        if isSelected {
            container.backgroundColor = .turquoise.withAlphaComponent(0.06)
            container.drawBorder(color: .clear)
            titleLabel.textColor = .darkTorquoise
        } else {
            container.backgroundColor = .white
            container.drawRoundedAndShadowedNew()
            titleLabel.textColor = .black
        }
    }
}

