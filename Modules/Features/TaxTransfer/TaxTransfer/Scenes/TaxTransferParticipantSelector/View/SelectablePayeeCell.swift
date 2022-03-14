//
//  SelectablePayeeCell.swift
//  TaxTransfer
//
//  Created by 185167 on 10/03/2022.
//

import CoreFoundationLib
import PLUI
import UI

final class SelectablePayeeCell: UITableViewCell {
    public static let identifier = String(describing: self)
    
    private let nameLabel = UILabel()
    private let locationLabel = UILabel()
    private let accountLabel = UILabel()
    private let tappableCard = TappableControl()
    private let checkImageView = UIImageView(image: PLAssets.image(named: "checkIcon"))
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        viewModel: SelectableTaxAuthorityViewModel,
        onTap: @escaping () -> ()
    ) {
        nameLabel.text = viewModel.name
        locationLabel.text = viewModel.location
        accountLabel.text = viewModel.accountNumber
        tappableCard.onTap = onTap
        configureStyling(isSelected: viewModel.isSelected)
    }
    
    private func setUp() {
        configureSelectionStyle()
        configureSubviews()
        configureLabels()
    }
    
    private func configureSelectionStyle() {
        selectionStyle = .none
    }
    
    private func configureSubviews() {
        contentView.addSubview(tappableCard)
        tappableCard.translatesAutoresizingMaskIntoConstraints = false
        
        [nameLabel, stackView, checkImageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [locationLabel, accountLabel].forEach(stackView.addArrangedSubview)
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            tappableCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tappableCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tappableCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tappableCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: tappableCard.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: tappableCard.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: tappableCard.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: tappableCard.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: tappableCard.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: tappableCard.bottomAnchor, constant: -10),

            checkImageView.centerXAnchor.constraint(equalTo: tappableCard.trailingAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: tappableCard.topAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 17),
            checkImageView.heightAnchor.constraint(equalToConstant: 17)
        ])
    }
    
    private func configureLabels() {
        nameLabel.font = .santander(family: .micro, type: .bold, size: 16)
        locationLabel.font = .santander(family: .micro, type: .regular, size: 14)
        accountLabel.font = .santander(family: .micro, type: .regular, size: 14)
    }
    
    private func configureStyling(isSelected: Bool) {
        checkImageView.isHidden = !isSelected
        
        if isSelected {
            tappableCard.backgroundColor = .turquoise.withAlphaComponent(0.06)
            tappableCard.drawBorder(color: .clear)
            
            [nameLabel, locationLabel, accountLabel].forEach {
                $0.textColor = .darkTorquoise
            }
        } else {
            tappableCard.backgroundColor = .white
            tappableCard.drawRoundedAndShadowedNew()
            
            nameLabel.textColor = .lisboaGray
            locationLabel.textColor = .brownishGray
            accountLabel.textColor = .brownishGray
        }
    }
}

