import UIKit
import CoreFoundationLib

class PLQuickBalanceSettingsInfoView: UIView {
    let title = UILabel()
    let text = UILabel()
    let background = UIView()

    init() {
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    func configureView(){
        title.text = localized("pl_quickView_title_howItWorks")
        title.font = UIFont.santander(family: .text, type: .bold, size: 18)
        text.text = localized("pl_quickView_text_howItWorks")
        text.font = UIFont.santander(family: .text, type: .light, size: 14)
        text.numberOfLines = 0
        text.textColor = UIColor(red: 68/255.0,
                                   green: 68/255.0,
                                   blue: 68/255.0,
                                   alpha: 1)

        background.backgroundColor = UIColor(red: 255/255.0,
                                                   green: 259/255.0,
                                                   blue: 233/255.0,
                                                   alpha: 1)
        background.layer.cornerRadius = 8

        addSubview(title)
        background.addSubview(text)
        addSubview(background)

        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ])

        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            background.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            background.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            text.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            text.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            text.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
    }
}
