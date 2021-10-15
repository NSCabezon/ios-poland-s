import Commons
import PLUI
import UI

typealias ValueFontStyle = LoanScheduleDetailsViewModel.ValueStyle

private enum Constants {
    static let titleFont = UIFont.santander(family: .micro, type: .regular, size: 16)
    static let valueFontBig = UIFont.santander(family: .headline, type: .bold, size: 32)
    static let valueFontMedium = UIFont.santander(family: .headline, type: .bold, size: 24)
    static let valueFontSmall = UIFont.santander(family: .headline, type: .bold, size: 18)
    static let titleColor = UIColor.brownishGray
    static let valueColor = UIColor.lisboaGray
}

final class LoanScheduleDetailValueView: UIView {
    
    private let titleLabel: UILabel = UILabel()
    private let valueLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        setUpSubviews()
        setUpLayout()
        setUpStyle()
    }
    
    private func setUpSubviews() {
        addSubview(titleLabel)
        addSubview(valueLabel)
    }
    
    private func setUpLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setUpStyle() {
        titleLabel.textColor = Constants.titleColor
        titleLabel.font = Constants.titleFont
        valueLabel.textColor = Constants.valueColor
    }
    
    func setUp(title: String, value: String, fontStyle: ValueFontStyle) {
        titleLabel.text = title
        valueLabel.text = value
        
        valueLabel.font = fontStyle.font
    }
}

private extension ValueFontStyle {
    var font: UIFont {
        switch self {
        case .big: return Constants.valueFontBig
        case .medium: return Constants.valueFontMedium
        case .small: return Constants.valueFontSmall
        }
    }
}
