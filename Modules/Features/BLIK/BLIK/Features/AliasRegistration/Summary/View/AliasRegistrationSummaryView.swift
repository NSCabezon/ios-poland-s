//
//  AliasRegistrationSummaryView.swift
//  BLIK
//
//  Created by 185167 on 15/11/2021.
//

import UI
import Commons

final class AliasRegistrationSummaryView: UIView {
    private let infoLabel = UILabel()
    private let tipLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    func setInfoText(_ text: String) {
        infoLabel.text = text
    }
}

private extension AliasRegistrationSummaryView {
    func setUp() {
        configureSubviews()
        configureStyling()
        configureStaticTexts()
    }
    
    func configureSubviews() {
        [infoLabel, tipLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            
            tipLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            tipLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            tipLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            tipLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configureStyling() {
        infoLabel.textAlignment = .center
        infoLabel.textColor = .lisboaGray
        infoLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        tipLabel.textAlignment = .center
        tipLabel.textColor = .lisboaGray
        tipLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
    }
    
    func configureStaticTexts() {
        let tipText: String = localized("pl_blik_text_saveExpl")
        tipLabel.configureText(withLocalizedString: .plain(text: tipText))
    }
}
