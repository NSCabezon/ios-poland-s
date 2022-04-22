//
//  PayersWhiteListInfoView.swift
//  SplitPayment
//
//  Created by 189501 on 08/04/2022.
//

import UIKit
import PLUI

final class PayersWhiteListInfoView: UIView {
    
    let moreInfoButton = UIButton()
    
    private let container = UIView()
    private let infoIconImageView = UIImageView()
    private let infoLabel = UILabel()
    private let text: String
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
                   
    private func setUp() {
        addSubviews()
        configureView()
        setUpLayout()
    }
    
    private func addSubviews() {
        addSubview(container)
        container.addSubview(infoIconImageView)
        container.addSubview(infoLabel)
        container.addSubview(moreInfoButton)
    }
    
    private func configureView() {
        configureContainer()
        configureInfoIcon()
        configureInfoLabel()
        configureMoreInfoButton()
    }
    
    private func configureContainer() {
        container.backgroundColor = .sky
        container.layer.cornerRadius = 4
    }
    
    private func configureInfoIcon() {
        infoIconImageView.image = PLAssets.image(named: "info_blueGreen") ?? UIImage() //Images.info_blueGreen
    }
    
    private func configureInfoLabel() {
        infoLabel.text = text
        infoLabel.numberOfLines = 0
        infoLabel.font = .santander(family: .text, type: .regular, size: 14)
        infoLabel.textColor = .black
    }
    
    private func configureMoreInfoButton() {
        moreInfoButton.setTitle("#pl_split_payment_white_list_more_info", for: .normal)
        moreInfoButton.setTitleColor(.darkTorquoise, for: .normal)
        moreInfoButton.titleLabel?.textAlignment = .right
        moreInfoButton.titleLabel?.font = .santander(family: .text, type: .bold, size: 14)
        moreInfoButton.contentHorizontalAlignment = .right
    }
    
    private func setUpLayout() {
        container.translatesAutoresizingMaskIntoConstraints = false
        infoIconImageView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            infoIconImageView.widthAnchor.constraint(equalToConstant: 24),
            infoIconImageView.heightAnchor.constraint(equalToConstant: 24),
            infoIconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            infoIconImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            
            infoLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            infoLabel.leadingAnchor.constraint(equalTo: infoIconImageView.trailingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            
            moreInfoButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            moreInfoButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
            moreInfoButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            moreInfoButton.heightAnchor.constraint(equalToConstant: 30),
            moreInfoButton.leadingAnchor.constraint(lessThanOrEqualTo: container.leadingAnchor, constant: 10)
        ])
    }
    
}
