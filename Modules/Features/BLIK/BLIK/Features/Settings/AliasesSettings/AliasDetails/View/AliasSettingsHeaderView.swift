//
//  AliasSettingsHeaderView.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 03/09/2021.
//

final class AliasSettingsHeaderView: UIView {
    private let aliasName = UILabel()
    private let expirationDate = UILabel()
    private let icon = UIImageView()
    private let separator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setViewModel(_ viewModel: AliasSettingsViewModel) {
        aliasName.text = viewModel.aliasName
        expirationDate.text = viewModel.expirationDate
        icon.isHidden = false
        separator.isHidden = false
    }
    
    private func setUp() {
        configureSubviews()
        configureStyling()
        hideElementsBeforeViewModelFill()
    }
    
    private func configureSubviews() {
        [aliasName, expirationDate, icon, separator].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 55),
            icon.heightAnchor.constraint(equalToConstant: 55),
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            icon.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -20),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            
            aliasName.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            aliasName.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            aliasName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            
            expirationDate.topAnchor.constraint(equalTo: aliasName.bottomAnchor, constant: 4),
            expirationDate.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            expirationDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            expirationDate.bottomAnchor.constraint(lessThanOrEqualTo: separator.topAnchor, constant: 0),
            
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func configureStyling() {
        separator.backgroundColor = .mediumSkyGray
        icon.image = Images.Settings.securityLock
        icon.contentMode = .scaleAspectFit
        
        aliasName.textColor = .lisboaGray
        aliasName.font = .santander(
            family: .micro,
            type: .bold,
            size: 16
        )
        
        expirationDate.textColor = .brownishGray
        expirationDate.font = .santander(
            family: .micro,
            type: .regular,
            size: 16
        )
    }
    
    private func hideElementsBeforeViewModelFill() {
        separator.isHidden = true
        icon.isHidden = true
    }
}
