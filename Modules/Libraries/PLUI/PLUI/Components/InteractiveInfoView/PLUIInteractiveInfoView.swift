//
//  PLUIInteractiveInfoView.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 7/7/21.
//

import Foundation
import UI

public protocol PLUIInteractiveInfoViewDelegate: AnyObject {
    func interactiveInfoView(_ :PLUIInteractiveInfoView, didChangeSwitch value: Bool)
}

public class PLUIInteractiveInfoView: UIView {

    let image: UIImage?
    let title: String
    let text: String
    public weak var delegate: PLUIInteractiveInfoViewDelegate?

    private enum Constants {
        static let horizontalSpacing: CGFloat = 10.0
        static let verticalSpacing: CGFloat = 5.0
        static let titleFont =  UIFont.santander(family: .text, type: .bold, size: 16)
        static let descriptionFont =  UIFont.santander(family: .micro, type: .regular, size: 14)
        static let titleTextColor = UIColor(red: 87.0 / 255.0, green: 87.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
        static let descriptionTextColor = UIColor(red: 114.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    }

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.verticalSpacing
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        return switcher
    }()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        return label
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        return view
    }()

    public init(image: UIImage? = nil, title: String, text: String) {
        self.image = image
        self.title = title
        self.text = text
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()
        self.configureViews()
        self.addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PLUIInteractiveInfoView {

    func configureViews() {
        self.titleLabel.text = self.title
        self.titleLabel.font = Constants.titleFont
        self.titleLabel.textColor = Constants.titleTextColor

        self.descriptionLabel.text = self.text
        self.descriptionLabel.font = Constants.descriptionFont
        self.descriptionLabel.textColor = Constants.descriptionTextColor

        self.switcher.addTarget(self, action: #selector(switcherDidChangeValue), for: .valueChanged)
    }

    func addSubviews() {
        self.addSubview(self.backgroundView)
        self.verticalStackView.addArrangedSubview(self.titleLabel)
        self.verticalStackView.addArrangedSubview(self.descriptionLabel)

        if let image = self.image {
            self.imageView.image = image
            self.addSubview(self.imageView)
        }
        self.addSubview(self.verticalStackView)
        self.addSubview(self.switcher)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15.0),
            self.verticalStackView.leadingAnchor.constraint(equalTo: (self.image != nil ? self.imageView.trailingAnchor : self.leadingAnchor), constant: Constants.horizontalSpacing),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.switcher.leadingAnchor, constant: -Constants.horizontalSpacing),

            self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1.0),
            self.backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2.0),

            self.switcher.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.switcher.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])

        if self.image != nil {
            NSLayoutConstraint.activate([
                self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0),
                self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
                self.imageView.widthAnchor.constraint(equalToConstant: 44.0),
                self.imageView.heightAnchor.constraint(equalToConstant: 44.0),
            ])
        }
    }

    @objc func switcherDidChangeValue(_ sender: UISwitch) {
        self.delegate?.interactiveInfoView(self, didChangeSwitch: sender.isOn)
    }
}
