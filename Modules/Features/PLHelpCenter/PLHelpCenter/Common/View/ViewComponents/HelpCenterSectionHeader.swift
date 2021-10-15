//
//  HelpCenterSectionHeader.swift
//  HelpCenterSectionHeader
//
//  Created by 186490 on 06/08/2021.
//

import UI
import Commons

private enum Constants {
    // TODO: Move colors to the separate module
    static let textColor = UIColor(red: 114.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    static let textFont = UIFont.santander(family: .headline, type: .bold, size: 18.0)
    static let topMargin: CGFloat = 20
    static let leftMargin: CGFloat = 16
    static let rightMargin: CGFloat = -16
    static let bottomMargin: CGFloat = -20
}

final class HelpCenterSectionHeader: UITableViewHeaderFooterView {
    public static var identifier = "PLHelpCenterSectionHeaderView"
    
    private let titleLabel = UILabel()
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setText(_ text: String) {
        titleLabel.text = text
        setNeedsLayout()
    }
    
    private func setup() {
        setupSubviews()
        setupLayout()
        setupTitleLabel()
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
    }
    
    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topMargin),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.leftMargin),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: Constants.rightMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.bottomMargin)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.applyStyle(LabelStylist(textColor: Constants.textColor, font: Constants.textFont, textAlignment: .left))
    }

}

extension HelpCenterSectionHeader: SectionViewModelSetUpable {
    func setUp(with viemodel: HelpCenterSectionViewModel) {
        titleLabel.text = viemodel.sectionType.title
    }
}

private extension HelpCenterConfig.SectionType {
    var title: String {
        switch self {
        case .hints(let title): return title
        case .inAppActions: return localized("pl_helpdesk_text_inApp")
        case .call: return localized("pl_helpdesk_text_HelpLine")
        case .onlineAdvisor: return localized("pl_helpdesk_text_onlineHelp")
        case .mail: return localized("pl_helpdesk_text_mailApp")
        case .contact: return "" // Header is not visible for this case
        case .conversationTopic: return localized("pl_helpdesk_text_chooseSubject")
        }
    }
}
