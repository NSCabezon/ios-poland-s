import UIKit
import CoreFoundationLib

class PLQuickBalanceSettingsViewExample: UIView {
    let title = UILabel()
    let image = UIImageView()

    init() {
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    func configureView(){
        addSubview(title)
        addSubview(image)

        title.text = localized("pl_quickView_title_examples")
        title.font = UIFont.santander(family: .text, type: .bold, size: 18)

        image.image = UIImage(named: "intro", in: .module, compatibleWith: nil)
        image.contentMode =  .scaleAspectFit

        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor)
        ])

        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            image.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
