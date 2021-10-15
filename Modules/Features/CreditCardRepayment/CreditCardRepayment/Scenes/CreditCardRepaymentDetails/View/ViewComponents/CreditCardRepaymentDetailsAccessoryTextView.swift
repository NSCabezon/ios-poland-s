//
//  CreditCardRepaymentDetailsAccessoryTextView.swift
//  CreditCardRepayment
//
//  Created by 186490 on 10/06/2021.
//

import UI

private enum Constants {
    // TODO: Move colors to the separate module
    static let backgroundColor: UIColor = .clear

    // Label
    static let labelTextColor = UIColor(red: 114.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    static let labelFont = UIFont.santander(family: .text, type: .regular, size: 14)
    static let labelLeftMargin: CGFloat = 8
}

extension CreditCardRepaymentDetailsView {
    final class AccessoryTextView: UIView {
        private let label = UILabel()

        override init(frame: CGRect) {
            super.init(frame: .zero)

            setup()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setText(_ text: String) {
            label.text = text
        }

        private func setup() {
            setupView()
            setupSubviews()
            setupLayouts()
        }

        private func setupView() {
            backgroundColor = Constants.backgroundColor
            addSubview(label)
        }

        private func setupSubviews() {
            label.applyStyle(LabelStylist(textColor: Constants.labelTextColor,
                                          font: Constants.labelFont,
                                          textAlignment: .left))
        }

        private func setupLayouts() {
            label.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.labelLeftMargin),
                label.trailingAnchor.constraint(equalTo: trailingAnchor),
                label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
}
