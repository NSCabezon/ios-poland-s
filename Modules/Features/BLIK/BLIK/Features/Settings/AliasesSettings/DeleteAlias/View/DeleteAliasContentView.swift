//
//  DeleteAliasView.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 06/09/2021.
//

import PLUI

final class DeleteAliasContentView: UIView {
    private let image = UIImageView()
    private let deleteAliasMessageTitle = UILabel()
    private let deleteAliasMessage = UILabel()
    private let fraudTransactionMessage = UILabel()
    private let fraudTransactionCheckbox = GlobileCheckBox()
    
    var didCheckFraudTransactionCheckbox: Bool {
        return fraudTransactionCheckbox.isSelected
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setViewModel(_ viewModel: DeleteAliasViewModel) {
        deleteAliasMessageTitle.text = viewModel.deleteAliasMessageTitle
        deleteAliasMessage.text = viewModel.deleteAliasMessage
        fraudTransactionMessage.text = viewModel.fraudTransactionMessage
    }
    
    private func setUp() {
        configureSubviews()
        configureStyling()
    }
    
    private func configureSubviews() {
        [
            image,
            deleteAliasMessageTitle,
            deleteAliasMessage,
            fraudTransactionMessage,
            fraudTransactionCheckbox
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 51),
            image.widthAnchor.constraint(equalToConstant: 51),
            image.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            deleteAliasMessageTitle.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            deleteAliasMessageTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            deleteAliasMessageTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            deleteAliasMessage.topAnchor.constraint(equalTo: deleteAliasMessageTitle.bottomAnchor, constant: 16),
            deleteAliasMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            deleteAliasMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            fraudTransactionCheckbox.topAnchor.constraint(equalTo: deleteAliasMessage.bottomAnchor, constant: 24),
            fraudTransactionCheckbox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fraudTransactionCheckbox.heightAnchor.constraint(equalToConstant: 30),
            fraudTransactionCheckbox.widthAnchor.constraint(equalToConstant: 30),
            
            fraudTransactionMessage.topAnchor.constraint(equalTo: deleteAliasMessage.bottomAnchor, constant: 24),
            fraudTransactionMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 62),
            fraudTransactionMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fraudTransactionMessage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 0)
        ])
    }
    
    func configureStyling() {
        backgroundColor = .white
        image.image = Images.info_lisboaGray
        
        deleteAliasMessageTitle.textAlignment = .center
        deleteAliasMessageTitle.numberOfLines = 0
        deleteAliasMessageTitle.textColor = .lisboaGray
        deleteAliasMessageTitle.font = .santander(
            family: .micro,
            type: .bold,
            size: 18
        )
        
        deleteAliasMessage.textAlignment = .center
        deleteAliasMessage.numberOfLines = 0
        deleteAliasMessage.textColor = .lisboaGray
        deleteAliasMessage.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
        
        fraudTransactionMessage.textAlignment = .left
        fraudTransactionMessage.numberOfLines = 0
        fraudTransactionMessage.textColor = .lisboaGray
        fraudTransactionMessage.font = .santander(
            family: .micro,
            type: .semibold,
            size: 12
        )
    }
}
