//
//  CreditCardRepaymentDetailsViewBottomView.swift
//  CreditCardRepayment
//
//  Created by 186490 on 09/06/2021.
//

import UI
import CoreFoundationLib

private enum Constants {
    // Separator
    static let separatorHeight: CGFloat = 1

    // Next button
    static let nextButtonHorizontalSpacing: CGFloat = 15
    static let nextButtonTopMargin: CGFloat = 12
    static let nextButtonHeight: CGFloat = 40
}

extension CreditCardRepaymentDetailsView {
    final class BottomView: UIView {
        var onTouchAction: (() -> Void)?
        var isEnabled: Bool = true {
            didSet {
                nextButton.isEnabled = isEnabled
            }
        }
        
        private let separatorView = UIView()
        private let nextButton = LisboaButton()

        override init(frame: CGRect) {
            super.init(frame: .zero)

            setup()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup() {
            setupView()
            setupSubviews()
            setupLayouts()
        }

        private func setupView() {
            backgroundColor = .white
            addSubview(separatorView)
            addSubview(nextButton)
        }

        private func setupSubviews() {
            setupSeparatorView()
            setupNextButtonView()
        }

        private func setupLayouts() {
            setupSeparatorViewConstraints()
            setupNextButtonViewConstraints()
        }

        private func setupSeparatorView() {
            separatorView.backgroundColor = .paleGrayTwo
        }

        private func setupNextButtonView() {
            nextButton.configureAsWhiteButton()
            nextButton.setTitle(localized("generic_button_continue"), for: .normal)
            nextButton.addAction { [weak self] in
                self?.onTouchAction?()
            }
        }

        private func setupSeparatorViewConstraints() {
            separatorView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
                separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
                separatorView.topAnchor.constraint(equalTo: topAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
            ])
        }

        private func setupNextButtonViewConstraints() {
            nextButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.nextButtonHorizontalSpacing),
                nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.nextButtonHorizontalSpacing),
                nextButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.nextButtonTopMargin),
                nextButton.heightAnchor.constraint(equalToConstant: Constants.nextButtonHeight)
            ])
        }
    }
}
