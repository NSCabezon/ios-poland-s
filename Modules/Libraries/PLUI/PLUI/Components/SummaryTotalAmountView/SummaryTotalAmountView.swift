import UI
import Commons
import CoreFoundationLib

public class SummaryTotalAmountView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .text, type: .semibold, size: 11)
        label.textColor = .brownishGray
        label.textAlignment = .center
        label.text = localized("pl_blik_text_total")
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lisboaGray
        label.textAlignment = .center
        return label
    }()

    private let container = UIView()
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, totalLabel])

    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func setAmount(_ total: NSAttributedString) {
        totalLabel.attributedText = total
    }
}

private extension SummaryTotalAmountView {
    func setup() {
        addSubview(container)
        container.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 18, left: 16, bottom: 8, right: 16)
        container.backgroundColor = .lightGray40
        setupLayout()
        setIdentifiers()
    }
    
    func setupLayout() {
        container.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    func setIdentifiers() {
        self.accessibilityIdentifier = AccessibilityCommons.TotalAmountView.root.id
        titleLabel.accessibilityIdentifier = AccessibilityCommons.TotalAmountView.titleLabel.id
        totalLabel.accessibilityIdentifier = AccessibilityCommons.TotalAmountView.totalLabel.id
    }
}
