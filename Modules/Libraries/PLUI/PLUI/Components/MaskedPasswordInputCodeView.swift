//
//  MaskedPasswordInputCodeView.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 19/5/21.
//

import UIKit

public final class MaskedPasswordInputCodeView: InputCodeView {

    private enum Constants {
        static let positionsNumber = 20
        static let rowsNumber = 2
        static let elementsPerRow = positionsNumber/rowsNumber
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

    public init(requestedPositions: [NSInteger], delegate: InputCodeViewDelegate?) {
        super.init(keyboardType: .default, delegate: delegate)

        for position in 1...Constants.positionsNumber {
            self.inputBoxArray.append(InputCodeBoxView(position: position,
                                                       showPosition: true,
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
}

private extension MaskedPasswordInputCodeView {

    func addSubviews() {

        for row in 1...Constants.rowsNumber {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = Constants.spacingBetweenColumns
            stackView.translatesAutoresizingMaskIntoConstraints = false

            for position in 0...Constants.elementsPerRow-1 {
                stackView.addArrangedSubview(self.inputBoxArray[position + (row-1) * 10])
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
