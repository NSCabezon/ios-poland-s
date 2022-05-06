//
//  IrpWarningSectionView.swift
//  TaxTransfer
//
//  Created by 185167 on 22/02/2022.
//

import PLUI
import CoreFoundationLib

final class IrpWarningSectionView: UIView {
    private let warningView = WarningBubbleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatible with truth and beauty!")
    }
    
    private func setUp() {
        configureLayout()
        warningView.configure(with: localized("pl_taxTransfer_notice"))
    }
    
    private func configureLayout() {
        addSubview(warningView)
        warningView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            warningView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            warningView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            warningView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            warningView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
}
