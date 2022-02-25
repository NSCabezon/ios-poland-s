//
//  GlobileCheckBox.swift
//  PLUI
//
//  Created by 187830 on 12/10/2021.
//

import UI
import UIKit

public enum GlobileCheckboxTintColor {
    case red
    case turquoise
}

public class GlobileCheckBox: UIControl {

    // MARK: Colors

    private let textColor = UIColor.mediumSanGray
    private let infoButtonColor = UIColor.mediumSanGray

    /// A Boolean value indicating whether the info button is enabled.
    public var infoButtonEnabled: Bool = false {
        didSet {
            infoButton.isHidden = !infoButtonEnabled
        }
    }

    /// A Boolean value indicating whether the control is in the selected state.
    public override var isSelected: Bool {
        didSet {
            checkboxButton.isSelected = isSelected
            updateLabel()
        }
    }

    /// The tint color to apply to the checkbox button.
    public var color: GlobileCheckboxTintColor = .red


    /// The current text that is displayed by the button.
    public var text: String?
    
    public var checkboxSize = 30.0 {
        didSet {
            setupLayout()
        }
    }
    public var fontSize = 16.0

    // MARK: Subviews

    private let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(PLAssets.image(named: "empty_checkbox"), for: .normal)
        return button
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let infoButton: UIButton = {
        let button = UIButton(type: .infoDark)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }

    // MARK: Private

    private func addSubviews() {
        addSubview(checkboxButton)
        addSubview(label)
        addSubview(infoButton)

        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            checkboxButton.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -12),
            checkboxButton.heightAnchor.constraint(equalToConstant: CGFloat(self.checkboxSize)),
            checkboxButton.widthAnchor.constraint(equalTo: checkboxButton.heightAnchor),
            checkboxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])

        NSLayoutConstraint.activate([
            infoButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
            infoButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4),
            infoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoButton.heightAnchor.constraint(equalToConstant: 18.0),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor),
            ])
    }
    
    private func setupViews() {
        backgroundColor = .clear

        label.textColor = textColor
        label.font = .santander(size: CGFloat(self.fontSize))
        infoButton.tintColor = infoButtonColor

        label.text = text
        checkboxButton.addTarget(self, action: #selector(checkboxButtonTapped(_:)), for: .touchUpInside)

        addTarget(self, action: #selector(selectView(_:)), for: .touchUpInside)
        
        switch color {
        case .red:
            checkboxButton.setImage(
                PLAssets.image(named: "selected_red_checkbox"),
                for: .selected
            )
        case .turquoise:
            checkboxButton.setImage(
                PLAssets.image(named: "selected_turquoise_checkbox"),
                for: .selected
            )
        }
    }
    
    private func updateLabel() {
        label.textColor = isSelected ? UIColor.black : UIColor.sanGreyDark
    }

    // MARK: Actions

    @objc func selectView(_ sender: UITapGestureRecognizer) {
        checkboxButton.isSelected.toggle()
        isSelected = checkboxButton.isSelected
        sendActions(for: .valueChanged)
    }

    @objc func checkboxButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        isSelected = sender.isSelected
        updateLabel()
        sendActions(for: .valueChanged)
    }
}
