//
//  PLUIInputCodePinFacade.swift
//  PLUI

import UIKit
import UI

public final class PLUIInputCodePinFacade {

    public init() {}

    private enum Constants {
        static let elementsNumber = 4
        static let elementWidth: CGFloat = 55.0
        static let elementHeight: CGFloat = 56.0
        static let spacingBetweenColumns: CGFloat = 2.0
        static let font = UIFont.systemFont(ofSize: 30)
        static let cursorTintColor = UIColor.Legacy.sanRed
        static let textTintColor = UIColor.init(red: 19/255, green: 126/255, blue: 132/255, alpha: 1.0)
    }

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.spacingBetweenColumns
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
}

extension PLUIInputCodePinFacade: PLUIInputCodeFacadeProtocol {

    public func view(with boxes: [PLUIInputCodeBoxView]) -> UIView {
        for position in 1...boxes.count {
            self.horizontalStackView.addArrangedSubview(boxes[position-1])
            boxes[position-1].backgroundColor = .white
            if position == 1 {
                boxes[position-1].configureCorners(corners: [.topLeft, .bottomLeft], radius: 6)
            }
            if position == boxes.count {
                boxes[position-1].configureCorners(corners: [.topRight, .bottomRight], radius: 6)
            }
         }
         // Embed stackView in a container view to center it
         let container = UIView()
         container.addSubview(horizontalStackView)
         container.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            horizontalStackView.widthAnchor.constraint(equalToConstant: getControlLength()),
            horizontalStackView.heightAnchor.constraint(equalToConstant: Constants.elementHeight),
            horizontalStackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: container.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
         ])
         return container
    }

    public func configuration() -> PLUIInputCodeFacadeConfiguration {
        return PLUIInputCodeFacadeConfiguration(showPositions: false,
                                                showSecureEntry: true,
                                                elementsNumber: Constants.elementsNumber,
                                                font: Constants.font,
                                                cursorTintColor: Constants.cursorTintColor,
                                                textColor: Constants.textTintColor,
                                                borderColor: UIColor.init(red: 219/255, green: 224/255, blue: 227/255, alpha: 1.0),
                                                borderWidth: 1)
    }

    private func getControlLength() -> CGFloat {
        let boxesLength = CGFloat(Constants.elementsNumber) * Constants.elementWidth
        let spaceLength = Constants.spacingBetweenColumns * CGFloat(Constants.elementsNumber - 1)
        let controlLength = boxesLength + spaceLength
        return CGFloat(controlLength)
    }
}

