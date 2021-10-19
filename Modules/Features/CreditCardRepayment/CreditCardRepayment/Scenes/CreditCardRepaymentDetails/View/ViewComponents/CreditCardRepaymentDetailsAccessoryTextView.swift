//
//  CreditCardRepaymentDetailsAccessoryTextView.swift
//  CreditCardRepayment
//
//  Created by 186490 on 10/06/2021.
//

import UI

private enum Constants {
    // Label
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
            backgroundColor = .clear
            addSubview(label)
        }

        private func setupSubviews() {
            label.applyStyle(LabelStylist(textColor: .brownishGray,
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
