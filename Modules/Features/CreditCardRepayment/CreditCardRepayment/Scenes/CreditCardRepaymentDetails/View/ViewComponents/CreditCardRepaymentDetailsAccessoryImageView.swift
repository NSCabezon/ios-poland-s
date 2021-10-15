//
//  CreditCardRepaymentDetailsAccessoryImageView.swift
//  CreditCardRepayment
//
//  Created by 186490 on 10/06/2021.
//

import Foundation
import UIKit

private enum Constants {
    // TODO: Move colors to the separate module
    static let backgroundColor: UIColor = .clear

    // Image
    static let imageLeftMargin: CGFloat = 8
    static let imageHeight: CGFloat = 24
    static let imageWidth: CGFloat = 24
}

extension CreditCardRepaymentDetailsView {
    final class AccessoryImageView: UIView {
        enum Icon {
            case calendar
        }

        private let imageView = UIImageView()

        override init(frame: CGRect) {
            super.init(frame: .zero)

            setup()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setIcon(_ icon: Icon) {
            imageView.image = icon.image
        }

        private func setup() {
            setupView()
            setupLayouts()
        }

        private func setupView() {
            backgroundColor = Constants.backgroundColor
            addSubview(imageView)
        }

        private func setupLayouts() {
            imageView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.imageLeftMargin),
                imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
                imageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
}

private extension CreditCardRepaymentDetailsView.AccessoryImageView.Icon {
    var image: UIImage? {
        switch self {
        case .calendar:
            return UIImage(named: "calendar", in: .module, compatibleWith: nil)
        }
    }
}
