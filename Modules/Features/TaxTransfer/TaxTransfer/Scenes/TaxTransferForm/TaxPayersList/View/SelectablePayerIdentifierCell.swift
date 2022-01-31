//
//  SelectablePayerIdentifierCell.swift
//  TaxTransfer
//
//  Created by 187831 on 17/01/2022.
//

import UI
import PLUI

final class SelectablePayerIdentifierCell: UITableViewCell {
    public static let identifier = String(describing: self)
    
    private let container = UIView()
    private let identifierLabel = UILabel()
    private let checkImageView = UIImageView(image: PLAssets.image(named: "checkIcon"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(with identifier: String, isSelected: Bool = false) {
        identifierLabel.text = identifier
        
        configureStyling(isSelected: isSelected)
    }
    
    private func setUp() {
        configureStyling()
        configureSubview()
        configureSelectionStyle()
    }
    
    private func configureSelectionStyle() {
        selectionStyle = .none
    }
    
    private func configureSubview() {
        contentView.addSubview(container)
        
        [identifierLabel, checkImageView].forEach {
            container.addSubview($0)
        }
        
        [container, identifierLabel, checkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            identifierLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            identifierLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            checkImageView.centerXAnchor.constraint(equalTo: container.trailingAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: container.topAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 17),
            checkImageView.heightAnchor.constraint(equalToConstant: 17)
        ])
    }
    
    private func configureStyling() {
        identifierLabel.textAlignment = .left
        identifierLabel.font = .santander(family: .micro, type: .bold, size: 14)
    }
    
    private func configureStyling(isSelected: Bool) {
        checkImageView.isHidden = !isSelected
        
        if isSelected {
            container.backgroundColor = .turquoise.withAlphaComponent(0.06)
            container.drawBorder(color: .clear)
            
            identifierLabel.textColor = .darkTorquoise
        } else {
            container.backgroundColor = .white
            container.drawRoundedAndShadowedNew()
            
            identifierLabel.textColor = .black
        }
    }
}
