//
//  MaskedPasswordView.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 19/5/21.
//

import UIKit

public protocol MaskedPasswordViewDelegate: AnyObject {
    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, didChange string: String, for position: NSInteger)
    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, willChange string: String, for position: NSInteger) -> Bool
    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, didBeginEditing position: NSInteger)
    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, didEndEditing position: NSInteger)
    func maskedPasswordView(_ maskedPasswordView: MaskedPasswordView, didDelete position: NSInteger)
}

public final class MaskedPasswordView: UIView {

    private enum Constants {

        static let positionsNumber = 20
        static let elementsPerRow = 10
        static let rowsNumber = Int(positionsNumber/elementsPerRow)
        static let spacingBetweenRows: CGFloat = 5.0
        static let spacingBetweenColumns: CGFloat = 1.0
    }

    private lazy var verticalStackView: UIStackView = {

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.spacingBetweenRows
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var passwordInputBoxesArray = [PasswordInputBoxView]()
    private let requestedPositions: [NSInteger]
    private var keyboardType: UIKeyboardType
    private let delegate: MaskedPasswordViewDelegate?

    weak var maskedPasswordViewDelegate: MaskedPasswordViewDelegate?

    public init(requestedPositions: [NSInteger],
         keyboardType: UIKeyboardType = .default,
         showPositions: Bool = false,
         delegate: MaskedPasswordViewDelegate?) {

        self.requestedPositions = requestedPositions
        self.keyboardType = keyboardType
        self.delegate = delegate
        super.init(frame: .zero)

        for position in 1...Constants.positionsNumber {
            self.passwordInputBoxesArray.append(PasswordInputBoxView(position: position,
                                                                     showPosition: showPositions,
                                                                     delegate: self,
                                                                     enabled: requestedPositions.contains(where: { $0 == position })))
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult override public func resignFirstResponder() -> Bool {
        self.passwordInputBoxesArray.isAnyFirstResponder()?.resignFirstResponder()
        return true
    }

}

private extension MaskedPasswordView {

    func addSubviews() {
        for row in 1...Constants.rowsNumber {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = Constants.spacingBetweenColumns
            stackView.translatesAutoresizingMaskIntoConstraints = false

            for position in 0...Constants.elementsPerRow-1 {
                stackView.addArrangedSubview(self.passwordInputBoxesArray[position + (row-1) * 10])
                self.verticalStackView.addArrangedSubview(stackView)
            }
        }

        self.addSubview(self.verticalStackView)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

extension MaskedPasswordView: PasswordInputBoxViewDelegate {

    func passwordInputBoxViewShouldChangeString (_ paswwordInputBoxView: PasswordInputBoxView, replacementString string: String) -> Bool {
        let allowChange = self.delegate?.maskedPasswordView(self, willChange: string, for: paswwordInputBoxView.position)

        guard allowChange == true else {
            paswwordInputBoxView.text = ""
            return false
        }

        paswwordInputBoxView.text = string

        if let nextPasswordInputBoxView = self.passwordInputBoxesArray.nextEnabled(from: paswwordInputBoxView.position) {
            nextPasswordInputBoxView.becomeFirstResponder()
        } else {
            paswwordInputBoxView.resignFirstResponder()
        }

        self.delegate?.maskedPasswordView(self, didChange: string, for: paswwordInputBoxView.position)

        return true
    }

    func passwordInputBoxViewDidBeginEditing (_ paswwordInputBoxView: PasswordInputBoxView) {
        paswwordInputBoxView.setKeyboardType(self.keyboardType)
        self.delegate?.maskedPasswordView(self, didBeginEditing: paswwordInputBoxView.position)
    }

    func passwordInputBoxViewDidEndEditing (_ paswwordInputBoxView: PasswordInputBoxView) {
        self.delegate?.maskedPasswordView(self, didEndEditing: paswwordInputBoxView.position)
    }

    func passwordInputBoxViewDidDelete (_ paswwordInputBoxView: PasswordInputBoxView) {
        self.delegate?.maskedPasswordView(self, didDelete: paswwordInputBoxView.position)
    }
}

private extension Array where Element == PasswordInputBoxView {

    func nextEnabled(from position: NSInteger) -> PasswordInputBoxView? {
        guard position < self.count else { return nil }
        let next = self.first { $0.enabled == true && $0.position > position }
        return next
    }

    func isAnyFirstResponder() -> PasswordInputBoxView? {
        for passwordInputBoxView in self {
            if passwordInputBoxView.isFirstResponder {
                return passwordInputBoxView
            }
        }
        return nil
    }
}
