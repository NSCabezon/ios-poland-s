//
//  InputCodeSMSFacade.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 25/5/21.
//

import UIKit

public final class InputCodeSMSFacade {

    public init() {}

    private enum Constants {
        static let elementsNumber = 6
        static let spacingBetweenColumns: CGFloat = 10.0
    }

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.spacingBetweenColumns
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var hyphenView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.0
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 4).isActive = true
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        let contentView = UIView()
        contentView.addSubview(view)
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        return contentView
    }()
}

extension InputCodeSMSFacade: InputCodeFacade {
    
    public func view(with boxes: [InputCodeBoxView]) -> UIView {
        for position in 1...boxes.count {
            self.horizontalStackView.addArrangedSubview(boxes[position-1])
        }

        self.horizontalStackView.insertArrangedSubview(self.hyphenView, at: 3)
        return horizontalStackView
    }

    public func configuration() -> InputCodeFacadeConfiguration {
        return InputCodeFacadeConfiguration(showPositions: false,
                                            showSecureEntry: false,
                                            elementsNumber: Constants.elementsNumber)
    }
}
