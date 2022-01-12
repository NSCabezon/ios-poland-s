//
//  ContextSelectorCell.swift
//  PLContexts
//

import UIKit
import UI
import Commons
import SANPLLibrary

final class ContextSelectorCell: UITableViewCell {

    @IBOutlet private var contextView: UIView!
    @IBOutlet private var selectedContextImage: UIImageView!

    @IBOutlet private var abbreviationView: UIView!
    @IBOutlet private var abbreviationLabel: UILabel!

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contextTypeLabel: UILabel!

    func setup(with context: ContextSelectorViewModel) {
        self.selectionStyle = .none
        self.setupContextView(with: context)
        self.setupAbbreviation(with: context.abbreviation, andColor: context.abbreviationColor)
        self.nameLabel.text = context.formattedName
        self.nameLabel.textColor = context.textColor
        self.contextTypeLabel.text = context.typeName
        self.contextTypeLabel.textColor = context.textColor
    }

}

private extension ContextSelectorCell {
    private func setupContextView(with context: ContextSelectorViewModel) {
        let selected = context.selected
        self.contextView.backgroundColor = context.backgroundColor
        let shadowConfiguration = ShadowConfiguration(color: .gray, opacity: selected ? 0 : 0.3, radius: selected ? 0 : 3, withOffset: 1, heightOffset: 1)
        self.contextView.drawRoundedBorderAndShadow(with: shadowConfiguration, cornerRadius: 8, borderColor: .white, borderWith: 0)
        self.selectedContextImage.image = Assets.image(named: "icnCheckOvalGreen")
        self.selectedContextImage.isHidden = !selected
    }

    private func setupAbbreviation(with contextName: String, andColor color: UIColor) {
        self.abbreviationLabel.text = contextName
        self.abbreviationView.roundCorners(corners: .allCorners, radius: self.abbreviationView.frame.width)
        self.abbreviationView.backgroundColor = color
    }
}
