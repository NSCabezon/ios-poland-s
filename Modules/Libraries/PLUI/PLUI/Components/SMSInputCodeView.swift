//
//  SMSInputCodeView.swift
//  PLUI
//
//  Created by Marcos Álvarez Mesa on 25/5/21.
//

import UIKit

public final class SMSInputCodeView: InputCodeView {

    private enum Constants {
        static let positionsNumber = 6
        static let spacingBetweenColumns: CGFloat = 10.0
        static let boxSize = CGSize(width: 39.0, height: 56.0)
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

    public init(delegate: InputCodeViewDelegate?) {
        super.init(keyboardType: .decimalPad,
                   delegate: delegate)

        for position in 1...Constants.positionsNumber {
            self.inputBoxArray.append(InputCodeBoxView(position: position,
                                                                     showPosition: false,
                                                                     delegate: self,
                                                                     enabled: true,
                                                                     isSecureEntry: false,
                                                                     size: Constants.boxSize))
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SMSInputCodeView {

    func addSubviews() {

        for position in 1...Constants.positionsNumber {
            self.horizontalStackView.addArrangedSubview(self.inputBoxArray[position-1])
        }

        self.horizontalStackView.insertArrangedSubview(self.hyphenView, at: 3)
        self.addSubview(self.horizontalStackView)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            self.horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
