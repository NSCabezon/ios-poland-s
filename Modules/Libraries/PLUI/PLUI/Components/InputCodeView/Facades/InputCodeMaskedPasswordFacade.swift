//
//  InputCodeMaskedPasswordFacade.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 19/5/21.
//

import UIKit

public final class InputCodeMaskedPasswordFacade {

    public init() {}

    private enum Constants {
        static let elementsNumber = 20
        static let rowsNumber = 2
        static let elementsPerRow = elementsNumber/rowsNumber
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
}

extension InputCodeMaskedPasswordFacade: InputCodeFacade {

    public func view(with boxes: [InputCodeBoxView]) -> UIView {
        for row in 1...Constants.rowsNumber {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = Constants.spacingBetweenColumns
            stackView.translatesAutoresizingMaskIntoConstraints = false

            for position in 0...Constants.elementsPerRow-1 {
                stackView.addArrangedSubview(boxes[position + (row-1) * Constants.elementsPerRow])
                self.verticalStackView.addArrangedSubview(stackView)
            }
        }

        return self.verticalStackView
    }

    public func configuration() -> InputCodeFacadeConfiguration {
        return InputCodeFacadeConfiguration(showPositions: true,
                                            showSecureEntry: true,
                                            elementsNumber: Constants.elementsNumber)
    }
}
