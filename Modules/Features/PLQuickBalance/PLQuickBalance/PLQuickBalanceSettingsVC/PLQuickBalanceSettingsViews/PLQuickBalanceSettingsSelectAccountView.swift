import UIKit
import CoreFoundationLib
import PLUI

class PLQuickBalanceSettingsSelectAccountView: UIView {
    let title = UILabel()
    let subtitle = UILabel()
    let button = UIButton()

    init() {
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    func configureView() {
        addSubview(title)
        addSubview(subtitle)
        addSubview(button)

        title.font = UIFont.santander(family: .text, type: .bold, size: 12)
        subtitle.font = UIFont.santander(family: .text, type: .regular, size: 12)

        button.setTitle(localized("pl_quickView_label_change"), for: .normal)
        button.titleLabel?.font = UIFont.santander(family: .text, type: .bold, size: 12)
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(UIColor(red: 19/255.0,
                                     green: 126/255.0,
                                     blue: 132/255.0,
                                     alpha: 1),
                             for: .normal)

        button.contentHorizontalAlignment = .right

        makeConstraints()
    }

    func makeConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -12)
        ])

        subtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            subtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            subtitle.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -12),
            subtitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
