//
//  ChequeDetailsCell.swift
//  BLIK
//
//  Created by 186491 on 21/06/2021.
//

import UI
import UIKit
import PLCommons
import PLUI

final class ChequeDetailsCell: UITableViewCell {
    static public let identifier: String = "BLIK.ChequeDetailsCell"
    private lazy var titleLabel = makeTitleLabel()
    private lazy var dataLabel = makeDataLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setIdentifiers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewModel(_ viewModel: ChequeDetailsViewModel.Item) {
        titleLabel.text = viewModel.name
        dataLabel.text = viewModel.value
    }
}

private extension ChequeDetailsCell {
    func setUp() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dataLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),

            dataLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dataLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            dataLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .brownishGray
        label.font = .santander(family: .text, type: .semibold, size: 11)
        return label
    }
    
    func makeDataLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lisboaGray
        label.font = .santander(family: .text, type: .bold, size: 12)
        return label
    }
    
    func setIdentifiers() {
        titleLabel.accessibilityIdentifier = AccessibilityCheques.ChequeDetailsCell.titleLabel.id
        dataLabel.accessibilityIdentifier = AccessibilityCheques.ChequeDetailsCell.dataLabel.id
    }
}
