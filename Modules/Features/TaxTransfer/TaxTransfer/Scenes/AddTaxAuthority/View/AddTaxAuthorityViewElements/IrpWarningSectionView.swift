//
//  IrpWarningSectionView.swift
//  TaxTransfer
//
//  Created by 185167 on 22/02/2022.
//

import PLUI

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
        warningView.configure(with: "#Uwaga! Od 01.01.2020 zmienia się sposób składania przelewów podatkowych. Wybrany przelew podatkowy powinien zostać zrealizowany na indywidualny rachunek podatnika. Jeśli masz NIP lub PESEL podatnika, możesz uzyskać taki numer na stronie Ministerstwa Finansów lub we właściwym Urzędzie Skarbowym.")
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
