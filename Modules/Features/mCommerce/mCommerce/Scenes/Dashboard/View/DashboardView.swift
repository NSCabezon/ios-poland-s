import UI
import PLUI
import Commons

final class DashboardView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "mCommerce"
        let labelStylist = LabelStylist(textColor: .greyBlue,
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
        backgroundColor = .white
        
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
