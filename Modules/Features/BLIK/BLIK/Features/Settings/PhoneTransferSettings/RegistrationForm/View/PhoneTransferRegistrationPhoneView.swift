//
//  PhoneTransferRegistrationPhoneView.swift
//  BLIK
//
//  Created by 186491 on 23/07/2021.
//

import UI

final class PhoneTransferRegistrationPhoneView: UIView {
    private let titleLabel = UILabel()
    private let phoneLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: PhoneTransferRegistrationFormViewModel.PhoneViewModel) {
        titleLabel.text = viewModel.title
        phoneLabel.text = viewModel.phoneNumber
    }
}

private extension PhoneTransferRegistrationPhoneView {
    func setUp() {
        configureStyling()
        configureLayout()
    }
    
    func configureStyling() {
        titleLabel.textColor = .lisboaGray
        titleLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        phoneLabel.textColor = .lisboaGray
        phoneLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 17
        )
    }
    
    func configureLayout() {
        addSubview(titleLabel)
        addSubview(phoneLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            phoneLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            phoneLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            phoneLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            phoneLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
