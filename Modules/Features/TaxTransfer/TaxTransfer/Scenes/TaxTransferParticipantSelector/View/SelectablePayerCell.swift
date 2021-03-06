//
//  SelectablePayerCell.swift
//  TaxTransfer
//
//  Created by 187831 on 24/12/2021.
//

import CoreFoundationLib
import PLUI
import UI

final class SelectablePayerCell: UITableViewCell {
    public static let identifier = String(describing: self)
    
    private let payerShortNameLabel = UILabel()
    private let payerNameLabel = UILabel()
    private let payerTaxIdentifierLabel = UILabel()
    private let extraTaxIdentifierLabel = UILabel()
    private let extraTaxNameLabel = UILabel()
    private let container = UIView()
    private let tappableCard = TappableControl()
    private let checkImageView = UIImageView(image: PLAssets.image(named: "checkIcon"))
    
    private let leftStackView = UIStackView()
    private let rightStackView = UIStackView()
    private let emptyLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        extraTaxIdentifierLabel.text = ""
        extraTaxNameLabel.text = ""
    }
    
    func setUp(
        with viewModel: TaxTransferFormViewModel.TaxPayerViewModel,
        isSelected: Bool,
        onTap: @escaping () -> ()
    ) {
        payerNameLabel.text = viewModel.taxPayer.name
        payerShortNameLabel.text = viewModel.taxPayer.shortName
        
        tappableCard.onTap = onTap
        
        configureStyling(isSelected: isSelected)
        
        if let taxIdentifier = viewModel.taxPayer.taxIdentifier, !taxIdentifier.isEmpty {
            payerTaxIdentifierLabel.text = localized("pl_generic_docId_nip") + ": " + taxIdentifier
        }
        
        switch viewModel.taxPayerSecondaryIdentifier {
        case .available:
            let shouldShowExtraLabel = viewModel.hasDifferentTaxIdentifiers || payerTaxIdentifierLabel.text == nil
            
            [extraTaxIdentifierLabel,
             extraTaxNameLabel].forEach { $0.isHidden = !shouldShowExtraLabel }

            extraTaxIdentifierLabel.text = viewModel.taxPayer.secondaryTaxIdentifierNumber
            extraTaxNameLabel.text = viewModel.taxPayer.idType.displayableValue
        case .notAvailable:
            return
        }
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
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(leftStackView)
                
        [leftStackView,
        rightStackView,
        checkImageView].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [payerShortNameLabel,
        payerNameLabel,
        payerTaxIdentifierLabel].forEach(leftStackView.addArrangedSubview)
        
        [emptyLabel,
         extraTaxNameLabel,
         extraTaxIdentifierLabel].forEach(rightStackView.addArrangedSubview)
        
        [leftStackView,
         rightStackView].forEach {
            $0.axis = .vertical
            $0.distribution = .fillEqually
         }
        
        contentView.addSubview(tappableCard)
        tappableCard.translatesAutoresizingMaskIntoConstraints = false
        
        bringSubviewToFront(tappableCard)
        
        NSLayoutConstraint.activate([
            tappableCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            tappableCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tappableCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tappableCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            container.topAnchor.constraint(equalTo: tappableCard.topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: tappableCard.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: tappableCard.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: tappableCard.bottomAnchor),
            
            leftStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            leftStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            leftStackView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.6),
            leftStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            
            rightStackView.topAnchor.constraint(equalTo: leftStackView.topAnchor),
            rightStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            rightStackView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.4),
            rightStackView.bottomAnchor.constraint(equalTo: leftStackView.bottomAnchor),

            checkImageView.centerXAnchor.constraint(equalTo: container.trailingAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: container.topAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 17),
            checkImageView.heightAnchor.constraint(equalToConstant: 17)
        ])
    }
    
    private func configureLabels() {
        payerShortNameLabel.font = .santander(family: .micro, type: .bold, size: 16)
        payerNameLabel.font = .santander(family: .micro, type: .regular, size: 14)
        payerTaxIdentifierLabel.font = .santander(family: .micro, type: .regular, size: 12)
        
        extraTaxNameLabel.font = .santander(family: .micro, type: .regular, size: 14)
        extraTaxIdentifierLabel.font = .santander(family: .micro, type: .regular, size: 12)
        
        [extraTaxNameLabel,
         extraTaxIdentifierLabel].forEach { $0.textAlignment = .right }
    }
    
    private func configureStyling(isSelected: Bool) {
        checkImageView.isHidden = !isSelected
        
        if isSelected {
            container.backgroundColor = .turquoise.withAlphaComponent(0.06)
            container.drawBorder(color: .clear)
            
            [payerShortNameLabel,
             payerNameLabel,
             payerTaxIdentifierLabel,
             extraTaxNameLabel,
             extraTaxIdentifierLabel].forEach { $0.textColor = .darkTorquoise }
        } else {
            container.backgroundColor = .white
            container.drawRoundedAndShadowedNew()
            
            [payerShortNameLabel,
             payerNameLabel,
             payerTaxIdentifierLabel,
             extraTaxNameLabel,
             extraTaxIdentifierLabel].forEach { $0.textColor = .lisboaGray }
        }
    }
}
