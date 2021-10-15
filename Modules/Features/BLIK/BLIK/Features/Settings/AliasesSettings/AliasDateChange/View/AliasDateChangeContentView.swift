//
//  AliasDateChangeContentView.swift
//  BLIK
//
//  Created by 186491 on 19/09/2021.
//

import UIKit
import UI
import PLUI
import Commons

protocol AliasDateChangeContentViewDelegate: AnyObject {
    func didUpdateDate()
}

final class AliasDateChangeContentView: UIView {
    private let titleLabel = UILabel()
    private let periodSelector = AliasDatePeriodSelectorView()
    public weak var delegate: AliasDateChangeContentViewDelegate?
    
    public var selectedPeriod: AliasDateValidityPeriod?
    
    public init() {
        super.init(frame: .zero)
        configureSubviews()
        configureStyling()
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(viewModel: AliasDateChangeViewModel) {
        periodSelector.configureWithPeriods(AliasDateValidityPeriod.allCases) { [weak self] period in
            self?.selectedPeriod = period
            self?.delegate?.didUpdateDate()
        }
        periodSelector.selectElement(viewModel.selectedPeriod)
    }
}

private extension AliasDateChangeContentView {
    func configureContent() {
        titleLabel.text = localized("pl_blik_text_setDateInfo")
    }
    
    func configureSubviews() {
        addSubview(titleLabel)
        addSubview(periodSelector)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        periodSelector.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            periodSelector.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            periodSelector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            periodSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            periodSelector.heightAnchor.constraint(equalToConstant: 48),
            periodSelector.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureStyling() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .lisboaGray
        titleLabel.font = .santander(
            family: .text,
            type: .regular,
            size: 12
        )
    }
}
