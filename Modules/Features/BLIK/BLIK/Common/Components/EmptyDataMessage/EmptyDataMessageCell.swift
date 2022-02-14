//
//  EmptyDataMessageCell.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 15/06/2021.
//

import UIKit
import UI
import CoreFoundationLib
import PLCommons
import PLUI

final class EmptyDataMessageCell: UITableViewCell {
    static let identifier: String = "BLIK.EmptyDataMessageCell"
    private let title = UILabel()
    private let message = UILabel()
    private let backgroundImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setViewModel(_ viewModel: EmptyDataMessageViewModel) {
        let localizedTitle = localized(viewModel.titleLocalizableKey, [])
        title.configureText(
            withLocalizedString: localizedTitle,
            andConfiguration: .init(
                font: .santander(
                    family: .micro,
                    type: viewModel.titleFontType,
                    size: 18
                ),
                alignment: .center
            )
        )
        if let messageLocalizableKey = viewModel.messageLocalizableKey {
            message.attributedText = getAttributedMessageText(from: localized(messageLocalizableKey))
        } else {
            message.attributedText = nil
        }
    }
    
    private func setUp() {
        configureSubviews()
        applyStyling()
        setIdentifiers()
    }
    
    private func configureSubviews() {
        contentView.addSubview(backgroundImage)
        contentView.addSubview(title)
        contentView.addSubview(message)

        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            backgroundImage.heightAnchor.constraint(equalToConstant: 160),
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 56),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            message.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            message.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func applyStyling() {
        selectionStyle = .none
        backgroundImage.image = Images.Cheques.emptyListBackground
        title.textColor = .lisboaGray
        message.numberOfLines = 0
    }
    
    private func getAttributedMessageText(from text: String) -> NSAttributedString {
        let paragraphStyle: NSMutableParagraphStyle = {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = 6
            return style
        }()

        return NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.lisboaGray,
                .font: UIFont.santander(
                    family: .micro,
                    type: .regular,
                    size: 12
                ),
                .paragraphStyle: paragraphStyle
            ]
        )
    }
    
    private func setIdentifiers() {
        title.accessibilityIdentifier = AccessibilityCheques.EmptyDataMessageCell.title.id
        message.accessibilityIdentifier = AccessibilityCheques.EmptyDataMessageCell.message.id
        backgroundImage.accessibilityIdentifier = AccessibilityCheques.EmptyDataMessageCell.backgroundImage.id
    }
}
