//
//  DashboardView.swift
//  mCommerce
//

import UI
import PLUI
import Commons

private enum Constants {
    // TODO: Move colors to the separate module
    static let backgroundColor = UIColor.white
}

final class DashboardView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "mCommerce"
        // TODO: Move color to the separate module
        let labelColor = UIColor(red: 110.0 / 255.0, green: 110.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        let labelStylist = LabelStylist(textColor: labelColor,
                                        font: .santander(family: .micro, type: .bold, size: 11.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        backgroundColor = Constants.backgroundColor
        
        setUpSubviews()
        setUpLayout()
    }
    
    private func setUpSubviews() {
        addSubview(titleLabel)
    }
    
    private func setUpLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
