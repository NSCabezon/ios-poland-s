//
//  PLUIInputCodeSMSFacade.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 25/5/21.
//

import UIKit
import UI

public enum PLUIInputCodeSMSFacadeStyle {
    case blackBackground
    case whiteBackground
}

public final class PLUIInputCodeSMSFacade {
    
    private var facadeStyle:PLUIInputCodeSMSFacadeStyle = .blackBackground
    let cursorTintColor = UIColor.init(red: 19/255, green: 126/255, blue: 132/255, alpha: 1.0)
    let hyphenTintColor = UIColor.init(red: 219/255, green: 224/255, blue: 227/255, alpha: 1.0)

    public init(facadeStyle:PLUIInputCodeSMSFacadeStyle = .blackBackground) {
        self.facadeStyle = facadeStyle
    }

    private enum Constants {
        static let elementsNumber = 6
        static let font = UIFont.systemFont(ofSize: 22)
        static let hyphenSize = Screen.isScreenSizeBiggerThanIphone5() ? CGSize(width: 24.0, height: 4.0) : CGSize(width: 14, height: 4.0)
        static func getSpacingBetweenColumns(style: PLUIInputCodeSMSFacadeStyle) -> CGFloat {
            return style == .blackBackground ? 10.0 : 2.0
        }
    }

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.getSpacingBetweenColumns(style: facadeStyle)
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var hyphenView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.0
        view.backgroundColor = facadeStyle == .blackBackground ? .white : hyphenTintColor
        view.heightAnchor.constraint(equalToConstant: Constants.hyphenSize.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: Constants.hyphenSize.width).isActive = true
        let contentView = UIView()
        contentView.addSubview(view)
        contentView.widthAnchor.constraint(equalToConstant: Constants.hyphenSize.width*2).isActive = true
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        return contentView
    }()
}

extension PLUIInputCodeSMSFacade: PLUIInputCodeFacadeProtocol {
    
    public func view(with boxes: [PLUIInputCodeBoxView]) -> UIView {
        if facadeStyle == .whiteBackground {
            configureCorners(with: boxes)
        }
        for position in 1...boxes.count {
            self.horizontalStackView.addArrangedSubview(boxes[position-1])
        }
        self.horizontalStackView.insertArrangedSubview(self.hyphenView, at: 3)
        return horizontalStackView
    }

    public func configuration() -> PLUIInputCodeFacadeConfiguration {
        switch facadeStyle {
        case .blackBackground:
            return PLUIInputCodeFacadeConfiguration(showPositions: false,
                                                    showSecureEntry: true,
                                                    elementsNumber: Constants.elementsNumber,
                                                    font: Constants.font)
        case .whiteBackground:
            let borderColor = UIColor.init(red: 219/255, green: 224/255, blue: 227/255, alpha: 1.0)
            return PLUIInputCodeFacadeConfiguration(showPositions: false,
                                                    showSecureEntry: true,
                                                    elementsNumber: Constants.elementsNumber,
                                                    font: Constants.font,
                                                    cursorTintColor: cursorTintColor,
                                                    textColor: cursorTintColor,
                                                    borderColor: borderColor,
                                                    borderWidth: 1)
        }
    }
}

private extension PLUIInputCodeSMSFacade {
    func configureCorners(with boxes: [PLUIInputCodeBoxView]) {
        for position in 1...boxes.count {
            boxes[position-1].backgroundColor = .white
            if position == 1 {
                boxes[position-1].configureCorners(corners: [.topLeft, .bottomLeft], radius: 6)
            }
            if position == boxes.count {
                boxes[position-1].configureCorners(corners: [.topRight, .bottomRight], radius: 6)
            }
         }
    }
}
