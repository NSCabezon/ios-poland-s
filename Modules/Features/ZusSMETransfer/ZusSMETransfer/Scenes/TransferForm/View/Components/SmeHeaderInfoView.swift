
import PLUI
import UI
import CoreFoundationLib

final class SmeHeaderInfoView: UIView {
    let infoFirstPartLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SmeHeaderInfoView {
    func setUp() {
        addSubviews()
        configureView()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(infoFirstPartLabel)
    }
    func configureView() {
        infoFirstPartLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                                   font: .santander(family: .micro,
                                                                    type: .regular,
                                                                    size: 14),
                                                   textAlignment: .left))
        backgroundColor = .paleYellow
        infoFirstPartLabel.numberOfLines = 0
        infoFirstPartLabel.text = localized("pl_zusTransfer_text_splitPayment")
    }
    func setUpLayout() {
        infoFirstPartLabel.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoFirstPartLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            infoFirstPartLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoFirstPartLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoFirstPartLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
