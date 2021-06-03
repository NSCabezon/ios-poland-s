//
//  PLUIInputCodeSMSFacade.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 25/5/21.
//

import UIKit

public final class PLUIInputCodeSMSFacade {

    public init() {}

    private enum Constants {
        static let elementsNumber = 6
        static let spacingBetweenColumns: CGFloat = 10.0
        static let font =  UIFont.santander(family: .text, type: .regular, size: 28)
    }

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.spacingBetweenColumns
        stackView.distribution = .equalSpacing
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

extension PLUIInputCodeSMSFacade: PLUIInputCodeFacadeProtocol {
    
    public func view(with boxes: [PLUIInputCodeBoxView]) -> UIView {
        for position in 1...boxes.count {
            self.horizontalStackView.addArrangedSubview(boxes[position-1])
        }

        self.horizontalStackView.insertArrangedSubview(self.hyphenView, at: 3)
        return horizontalStackView
    }

    public func configuration() -> PLUIInputCodeFacadeConfiguration {
        return PLUIInputCodeFacadeConfiguration(showPositions: false,
                                                showSecureEntry: false,
                                                elementsNumber: Constants.elementsNumber,
                                                font: Constants.font)
    }
}
