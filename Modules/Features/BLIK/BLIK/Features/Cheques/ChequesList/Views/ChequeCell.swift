//
//  ChequeCell.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 14/06/2021.
//

import UIKit
import PLCommons

final class ChequeCell: UITableViewCell {
    static let identifier: String = "BLIK.ChequeCell"
    private let title = UILabel()
    private let amount = UILabel()
    private let icon = UIImageView()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setViewModel(_ viewModel: ChequeViewModel) {
        title.text = viewModel.title
        amount.text = viewModel.amount
    }
    
    private func setUp() {
        configureSubviews()
        applyStyling()
        setIdentifiers()
    }
    
    private func configureSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(title)
        containerView.addSubview(amount)
        containerView.addSubview(icon)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        amount.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        title.setContentHuggingPriority(.defaultHigh + 2, for: .vertical)
        amount.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            
            title.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -16),
            title.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13),
            
            amount.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            amount.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -16),
            amount.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            amount.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            icon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func applyStyling() {
        selectionStyle = .none
        title.textColor = .lisboaGray
        title.numberOfLines = 1
        title.font = .santander(
            family: .micro,
            type: .bold,
            size: 16
        )

        amount.textColor = .mediumSanGray
        amount.numberOfLines = 1
        amount.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
        icon.image = Images.chevron
        
        containerView.backgroundColor = .white
        containerView.drawRoundedBorderAndShadow(
            with: .init(color: .lightSanGray, opacity: 0.5, radius: 4, withOffset: 0, heightOffset: 2),
            cornerRadius: 4,
            borderColor: .mediumSkyGray,
            borderWith: 1
        )
    }
    
    private func setIdentifiers() {
        title.accessibilityIdentifier = AccessibilityCheques.ChequeCell.title.id
        amount.accessibilityIdentifier = AccessibilityCheques.ChequeCell.amount.id
        icon.accessibilityIdentifier = AccessibilityCheques.ChequeCell.icon.id
    }
}
