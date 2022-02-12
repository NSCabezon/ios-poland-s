//
//  OperatorSelectionTableViewCell.swift
//  PhoneTopUp
//
//  Created by 188216 on 20/01/2022.
//

import UIKit

final class OperatorSelectionTableViewCell: UITableViewCell {
    enum Style {
        case selected, unselected
    }

    // MARK: Identifier
    
    static let identifier = String(describing: OperatorSelectionTableViewCell.self)
    
    // MARK: Views
    
    private let borderView = UIView()
    private let nameLabel = UILabel()

    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    // MARK: Configuration
    
    func configure(with viewModel: OperatorSelectionCellViewModel) {
        nameLabel.text = viewModel.operatorName
        let style: Style = viewModel.isSelected ? .selected : .unselected
        setStyle(style)
    }
    
    private func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    private func addSubviews() {
        addSubviewConstraintToEdges(borderView, padding: UIEdgeInsets(top: 0, left: 0, bottom: 12.0, right: 0))
        borderView.addSubview(nameLabel)
    }
    
    private func prepareStyles() {
        selectionStyle = .none
        
        borderView.drawBorder(cornerRadius: 4.0, color: .mediumSkyGray, width: 1)
        
        nameLabel.font = .santander(family: .micro, type: .bold, size: 14.0)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func setUpLayout() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 12.0),
            nameLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -12.0),
            nameLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12.0),
            nameLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: 12.0),
        ])
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .selected:
            borderView.backgroundColor = .sky
            borderView.layer.borderWidth = 0.0
            nameLabel.textColor = .darkTorquoise
        case .unselected:
            borderView.backgroundColor = .white
            borderView.drawBorder(cornerRadius: 4.0, color: .mediumSkyGray, width: 1)
            nameLabel.textColor = .lisboaGray
        }
    }
}
