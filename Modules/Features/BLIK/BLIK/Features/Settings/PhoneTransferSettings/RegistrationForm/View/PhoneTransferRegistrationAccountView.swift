//
//  PhoneTransferRegistrationAccountView.swift
//  BLIK
//
//  Created by 186491 on 22/07/2021.
//

import UI
import CoreFoundationLib
import PLUI

final class PhoneTransferRegistrationAccountView: UIView {
    private var changeButtonPress: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let accountNameLabel = UILabel()
    private let amountLabel = UILabel()
    private let separatorView = UIView()
    private let editStackView = UIStackView()
    private let editImageView = UIImageView()
    private let editLabel = UILabel()
    private let editTapGestureRecognizer = UITapGestureRecognizer()
    private let editAndSeparatorStackView = UIStackView()
    private var editAndSeparatorStackViewZeroWidthConstraint: NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: PhoneTransferRegistrationFormViewModel.AccountViewModel) {
        titleLabel.text = viewModel.title
        accountNameLabel.text = viewModel.accountName
        amountLabel.text = viewModel.availableFunds
    }
    
    func setOnChangePress(_ onChangePress: @escaping () -> Void) {
        changeButtonPress = onChangePress
    }

    func shouldHideEditButton(_ hidden: Bool) {
        separatorView.isHidden = hidden
        editStackView.isHidden = hidden
        editAndSeparatorStackViewZeroWidthConstraint?.isActive = hidden
    }
    
    func configureTitleStyle(textColor: UIColor, font: UIFont) {
        titleLabel.textColor = textColor
        titleLabel.font = font
    }
    
    func configureAccountTextStyle(textColor: UIColor, font: UIFont) {
        accountNameLabel.textColor = textColor
        accountNameLabel.font = font
        amountLabel.textColor = textColor
        amountLabel.font = font
    }
}

private extension PhoneTransferRegistrationAccountView {
    func setUp() {
        configureStyling()
        configureLayout()
        configureTargets()
    }
    
    func configureStyling() {
        editLabel.textColor = .greyBlue
        editLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 9
        )
        editLabel.text = localized("pl_foundtrans_link_changeAccount")
        editLabel.textAlignment = .center
        
        editImageView.image = PLAssets.image(named: "editIcon")
        editImageView.contentMode = .center
        
        editStackView.axis = .vertical
        editStackView.distribution = .fill
        
        titleLabel.textColor = .lisboaGray
        titleLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        accountNameLabel.textColor = .lisboaGray
        accountNameLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 17
        )
        
        amountLabel.textColor = .lisboaGray
        amountLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 17
        )
        amountLabel.textAlignment = .right
        separatorView.backgroundColor = .paleGrey
        
    }
    
    func configureTargets() {
        editTapGestureRecognizer.addTarget(self, action: #selector(editTapGestureRecognizerAction))
        editStackView.addGestureRecognizer(editTapGestureRecognizer)
    }
    
    func configureLayout() {
        addSubview(titleLabel)
        addSubview(accountNameLabel)
        addSubview(amountLabel)
        addSubview(separatorView)
        addSubview(editStackView)
        addSubview(editAndSeparatorStackView)
        editStackView.addArrangedSubview(editImageView)
        editStackView.addArrangedSubview(editLabel)
        editStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        editAndSeparatorStackView.addArrangedSubview(separatorView)
        editAndSeparatorStackView.addArrangedSubview(editStackView)
        editAndSeparatorStackView.spacing = 6
        amountLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        accountNameLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        editStackView.translatesAutoresizingMaskIntoConstraints = false
        editAndSeparatorStackView.translatesAutoresizingMaskIntoConstraints = false
        editImageView.translatesAutoresizingMaskIntoConstraints = false
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        
        editAndSeparatorStackViewZeroWidthConstraint = editAndSeparatorStackView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            editAndSeparatorStackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            editAndSeparatorStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            editAndSeparatorStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            editStackView.widthAnchor.constraint(equalTo: editStackView.heightAnchor),
            
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: editAndSeparatorStackView.leadingAnchor, constant: -6),
            
            accountNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            accountNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            accountNameLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor),
            accountNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            amountLabel.topAnchor.constraint(equalTo: accountNameLabel.topAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc func editTapGestureRecognizerAction() {
        changeButtonPress?()
    }
}
