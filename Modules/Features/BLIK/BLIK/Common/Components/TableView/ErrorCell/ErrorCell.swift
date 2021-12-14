//
//  ErrorCell.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 23/06/2021.
//

import UIKit
import UI
import Commons
import PLCommons
import PLUI

final class ErrorCell: UITableViewCell {
    static let identifier = "BLIK.ErrorCell"
    private let icon = UIImageView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let refreshButton = WhiteLisboaButton()
    private var onRefreshButtonTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setViewModel(_ viewModel: ErrorCellViewModel) {
        title.text = viewModel.title
        subtitle.attributedText = getSubtitleAttributedText(for: viewModel.subtitle)
        
        switch viewModel.refreshButtonState {
        case .hidden:
            refreshButton.isHidden = true
        case let .present(refreshAction):
            refreshButton.isHidden = false
            onRefreshButtonTap = refreshAction
        }
    }
    
    private func setUp() {
        configureTargets()
        configureSubviews()
        applyStyling()
        setIdentifiers()
    }
    
    private func configureSubviews() {
        [icon, title, subtitle, refreshButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 64),
            icon.widthAnchor.constraint(equalToConstant: 64),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor),
            icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            subtitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            refreshButton.heightAnchor.constraint(equalToConstant: 48),
            refreshButton.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 36),
            refreshButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            refreshButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 160),
            refreshButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureTargets() {
        refreshButton.isUserInteractionEnabled = true
        refreshButton.addAction { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.onRefreshButtonTap?()
        }
    }
    
    private func applyStyling() {
        selectionStyle = .none
        icon.image = Images.error
        subtitle.numberOfLines = 0
        refreshButton.setTitle(localized("pl_blik_button_refresh"), for: .normal)
        
        title.numberOfLines = 0
        title.textAlignment = .center
        title.textColor = .lisboaGray
        title.font = .santander(
            family: .micro,
            type: .bold,
            size: 18
        )
    }
    
    private func getSubtitleAttributedText(for text: String) -> NSAttributedString {
        let paragraphStyle: NSMutableParagraphStyle = {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = 6
            return style
        }()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lisboaGray,
            .font: UIFont.santander(
                family: .micro,
                type: .regular,
                size: 12
            ),
            .paragraphStyle: paragraphStyle
        ]
        return NSAttributedString(
            string: text,
            attributes: attributes
        )
    }
    
    private func setIdentifiers() {
        icon.accessibilityIdentifier = AccessibilityCheques.ErrorCell.icon.id
        title.accessibilityIdentifier = AccessibilityCheques.ErrorCell.title.id
        subtitle.accessibilityIdentifier = AccessibilityCheques.ErrorCell.subtitle.id
        refreshButton.accessibilityIdentifier = AccessibilityCheques.ErrorCell.refreshButton.id
    }
}
