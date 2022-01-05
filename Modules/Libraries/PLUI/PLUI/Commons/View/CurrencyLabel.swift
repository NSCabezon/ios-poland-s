//
//  CurrencyLabel.swift
//  PLUI
//
//  Created by 185167 on 29/12/2021.
//

import UI

public final class CurrencyLabel: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getText() -> String {
        return label.text ?? ""
    }

    public func setText(_ text: String) {
        label.text = text
    }

    private func setUp() {
        applyStyling()
        configureSubviews()
    }

    private func applyStyling() {
        backgroundColor = .clear
        label.applyStyle(LabelStylist(textColor: UIColor(red: 114.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0),
                                      font: .santander(family: .text, type: .regular, size: 14),
                                      textAlignment: .left))
    }
    
    private func configureSubviews() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthAnchor.constraint(equalToConstant: 44)
        ])
    }
}

