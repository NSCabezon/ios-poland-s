//
//  CreditCardRepaymentDetailsViewMultilineButton.swift
//  CreditCardRepayment
//
//  Created by 186490 on 08/06/2021.
//

import UI

private enum Constants {
    // TODO: Move colors/fonts to the separate module
    static let backgroundColor: UIColor = .white
        static let titleEdgeInsets = UIEdgeInsets(top: 13, left: 15, bottom: 14, right: 15)
    static let titleFont = UIFont.santander(family: .micro, type: .bold, size: 16.0)
    static let titleColor = UIColor(white: 65.0 / 255.0, alpha: 1.0)
    static let descriptionFont = UIFont.santander(family: .micro, type: .regular, size: 14.0)
    static let descriptionColor = UIColor(white: 139.0 / 255.0, alpha: 1.0)

    // Shadow
    static let shadowWidthOffset: CGFloat = 4.0
    static let shadowHeightOffset: CGFloat = 3.0
}

extension CreditCardRepaymentDetailsView {
    final class MultilineButton: UIButton {
        private let paragraphStyle = NSMutableParagraphStyle()
        var isEdgesVisible: Bool = false {
            didSet { updateEdges() }
        }

        var onTouchAction: ((_ sender: MultilineButton) -> Void)?

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
        }

        private func setupView() {
            backgroundColor = Constants.backgroundColor
            contentHorizontalAlignment = .left

            titleLabel?.numberOfLines = 2
            titleLabel?.textAlignment = .left
            titleEdgeInsets = Constants.titleEdgeInsets

            addTarget(self, action: #selector(didTouch), for: .touchUpInside)

            paragraphStyle.lineSpacing = 3
        }

        @objc private func didTouch() {
            onTouchAction?(self)
        }

        func setTitle(_ title: String, description: String?, for state: UIControl.State = []) {
            let attributedTitle = NSMutableAttributedString(string: title,
                                                            attributes: [.font: Constants.titleFont,
                                                                         .foregroundColor: Constants.titleColor])

            if let description = description {
                attributedTitle.append(NSAttributedString(string: "\n"))

                let attributedDescription = NSMutableAttributedString(string: description,
                                                                      attributes: [.font: Constants.descriptionFont,
                                                                                   .foregroundColor: Constants.descriptionColor])
                attributedTitle.append(attributedDescription)
            }

            attributedTitle.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedTitle.length))

            setAttributedTitle(attributedTitle, for: state)
        }

        func updateEdges() {
            if isEdgesVisible {
                drawRoundedAndShadowedNew(widthOffSet: Constants.shadowWidthOffset, heightOffSet: Constants.shadowHeightOffset)
            } else {
                clearShadowAndEdges()
            }
        }
    }
}

private extension UIView {
    func clearShadowAndEdges() {
        drawRoundedAndShadowedNew(radius: 0, borderColor: .clear, widthOffSet: 0, heightOffSet: 0)
    }
}
