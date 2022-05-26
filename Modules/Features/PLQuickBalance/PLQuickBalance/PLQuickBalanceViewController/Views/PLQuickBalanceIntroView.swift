import Foundation
import UIKit
import UI
import CoreFoundationLib

protocol PLQuickBalanceIntroActionsDelegate: AnyObject {
    func closeIntro()
    func enableQuickBalance()
}

class PLQuickBalanceIntroView: UIView {
    weak var delegate: PLQuickBalanceIntroActionsDelegate?
    let backLogin = UIButton()
    let close = UIButton()
    let logo = UIImageView()
    let titleLabel = UILabel()
    let seperator = UIView()
    let subtitleLabel = UILabel()
    let descriptionLabel = UILabel()
    let button = UIButton()
    let icon = UIImageView()

    init() {
        super.init(frame: .zero)
        configireView()
        configureActions()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configireView()
        configureActions()
    }
    
    private func configureActions() {
        backLogin.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(enableAction), for: .touchUpInside)
    }
    
    @objc private func closeAction() {
        delegate?.closeIntro()
    }
    
    @objc private func enableAction() {
        delegate?.enableQuickBalance()
    }

    func configireView(){
        backgroundColor = UIColor(red: 244/255.0,
                                  green: 246/255.0,
                                  blue: 247/255.0,
                                  alpha: 1)
        addSubview(backLogin)
        addSubview(close)
        addSubview(logo)
        addSubview(titleLabel)
        addSubview(seperator)
        addSubview(subtitleLabel)
        addSubview(descriptionLabel)
        addSubview(button)
        addSubview(icon)

        backLogin.setImage(UIImage(named: "backLogin", in: .module, compatibleWith: nil), for: .normal)
        backLogin.contentMode = .scaleAspectFit

        close.setImage(UIImage(named: "close", in: .module, compatibleWith: nil), for: .normal)

        logo.image = UIImage(named: "logo", in: .module, compatibleWith: nil)

        icon.image = UIImage(named: "intro", in: .module, compatibleWith: nil)
        icon.contentMode =  .scaleAspectFit

        titleLabel.text = localized("pl_quickView_toolbar")
        subtitleLabel.text = localized("pl_quickView_title_financesAtThumb")
        descriptionLabel.text = localized("pl_quickView_text_financesAtThumb")

        titleLabel.font = UIFont.santander(family: .text, type: .bold, size: 26)
        subtitleLabel.font = UIFont.santander(family: .text, type: .bold, size: 14)
        descriptionLabel.font = UIFont.santander(family: .text, type: .light, size: 14)

        subtitleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0

        button.setTitle(localized("pl_quickView_button_enable"), for: .normal)
        button.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 14)
        button.backgroundColor = .santanderRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24

        seperator.backgroundColor = UIColor(red: 86/255.0,
                                            green: 88/255.0,
                                            blue: 89/255.0,
                                            alpha: 0.1)

        close.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            close.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            close.topAnchor.constraint(equalTo: topAnchor, constant: 48),
            close.heightAnchor.constraint(equalToConstant: 24),
            close.widthAnchor.constraint(equalToConstant: 24)
        ])

        backLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backLogin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backLogin.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            backLogin.heightAnchor.constraint(equalToConstant: 40),
            backLogin.widthAnchor.constraint(equalToConstant: 40)
        ])

        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            logo.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            logo.heightAnchor.constraint(equalToConstant: 50),
            logo.widthAnchor.constraint(equalToConstant: 50)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            titleLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 8)
        ])

        seperator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seperator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            seperator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            seperator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            seperator.heightAnchor.constraint(equalToConstant: 1)
        ])

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            subtitleLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 22)
        ])

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8)
        ])

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -64),
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])

        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            icon.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
