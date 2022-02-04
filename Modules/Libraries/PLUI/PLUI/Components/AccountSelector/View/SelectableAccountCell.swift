//
//  SelectableAccountCell.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 05/08/2021.
//
import Commons

public final class SelectableAccountCell: UITableViewCell {
    static let identifier = "BLIK.SelectableAccountCell"
    private let accountName = UILabel()
    private let accountNumber = UILabel()
    private let fundsDescription = UILabel()
    private let availableFunds = UILabel()
    private let cardContainer = UIView()
    private let checkImageView = UIImageView(image: PLAssets.image(named: "checkIcon"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setViewModel(_ viewModel: SelectableAccountViewModel) {
        accountName.text = viewModel.name
        accountNumber.text = viewModel.accountNumber
        fundsDescription.text = localized("pl_foundtrans_label_availFunds")
        availableFunds.text = viewModel.availableFunds
        
        if viewModel.isSelected {
            configureSelectedStyling()
        } else {
            configureUnselectedStyling()
        }
    }
    
    private func setUp() {
        configureLayout()
        configureBaseStyling()
    }
    
    private func configureLayout() {
        contentView.addSubview(cardContainer)
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        
        [accountName, accountNumber, fundsDescription, availableFunds, checkImageView].forEach {
            cardContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        accountName.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        fundsDescription.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        accountNumber.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        availableFunds.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        
        NSLayoutConstraint.activate([
            accountName.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            accountName.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            accountName.trailingAnchor.constraint(equalTo: fundsDescription.leadingAnchor, constant: -4),

            fundsDescription.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            fundsDescription.leadingAnchor.constraint(greaterThanOrEqualTo: accountNumber.trailingAnchor, constant: 16),
            fundsDescription.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            
            accountNumber.topAnchor.constraint(equalTo: accountName.bottomAnchor, constant: 4),
            accountNumber.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            accountNumber.bottomAnchor.constraint(lessThanOrEqualTo: cardContainer.bottomAnchor),
            
            availableFunds.topAnchor.constraint(equalTo: fundsDescription.bottomAnchor, constant: 4),
            availableFunds.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            availableFunds.bottomAnchor.constraint(lessThanOrEqualTo: cardContainer.bottomAnchor),
            
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkImageView.centerXAnchor.constraint(equalTo: cardContainer.trailingAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: cardContainer.topAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 17),
            checkImageView.heightAnchor.constraint(equalToConstant: 17)
            
        ])
    }
    
    private func configureBaseStyling() {
        selectionStyle = .none
        accountName.textColor = .lisboaGray
        accountName.font = .santander(
            family: .micro,
            type: .bold,
            size: 16
        )
        
        accountNumber.textColor = .brownishGray
        accountNumber.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        fundsDescription.textColor = .brownishGray
        fundsDescription.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
        
        availableFunds.textColor = .lisboaGray
        availableFunds.font = .santander(
            family: .micro,
            type: .semibold,
            size: 16
        )
        availableFunds.textAlignment = .right
    }
    
    private func configureUnselectedStyling() {
        checkImageView.isHidden = true
        accountName.textColor = .lisboaGray
        accountNumber.textColor = .brownishGray
        fundsDescription.textColor = .brownishGray
        availableFunds.textColor = .lisboaGray
        cardContainer.backgroundColor = .white
        cardContainer.drawRoundedBorderAndShadow(
            with: .init(
                color: .lightSanGray,
                opacity: 0.5,
                radius: 4,
                withOffset: 0,
                heightOffset: 2
            ),
            cornerRadius: 5,
            borderColor: .mediumSkyGray,
            borderWith: 1
        )
    }
    
    private func configureSelectedStyling() {
        checkImageView.isHidden = false
        accountName.textColor = .darkTorquoise
        accountNumber.textColor = .darkTorquoise
        fundsDescription.textColor = .darkTorquoise
        availableFunds.textColor = .darkTorquoise
        cardContainer.backgroundColor = .turquoise.withAlphaComponent(0.06)
        cardContainer.drawRoundedBorderAndShadow(
            with: .init(
                color: .lightSanGray,
                opacity: 0,
                radius: 0,
                withOffset: 0,
                heightOffset: 0
            ),
            cornerRadius: 5,
            borderColor: .mediumSkyGray,
            borderWith: 0
        )
    }
}
