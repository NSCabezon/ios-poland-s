//
//  MobileContactsTableHeaderView.swift
//  PhoneTopUp
//
//  Created by 188216 on 27/12/2021.
//

import UIKit

final class MobileContactsTableHeaderView: UITableViewHeaderFooterView {
    // MARK: Identifier
    
    static let identifier = String(describing: MobileContactsTableHeaderView.self)
    
    // MARK: Views
    
    private let characterLabel = UILabel()
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    // MARK: Configuration
    
    func configure(with character: Character) {
        characterLabel.text = String(character)
    }
    
    private func setUp() {
        addSubviews()
        prepareStyles()
    }
    
    private func addSubviews() {
        contentView.addSubviewConstraintToEdges(characterLabel, padding: UIEdgeInsets(top: 8, left: 16.0, bottom: 8, right: 16.0))
    }
    
    private func prepareStyles() {
        let whiteBackgroundView = UIView(frame: CGRect.zero)
        whiteBackgroundView.backgroundColor = .white
        backgroundView = whiteBackgroundView
        characterLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        characterLabel.font = .santander(family: .headline, type: .regular, size: 16.0)
        characterLabel.textColor = .lisboaGray
        characterLabel.textAlignment = .left
    }
}
