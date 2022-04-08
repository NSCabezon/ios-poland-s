
import PLUI
import UI

final class SmeHeaderInfoView: UIView {
    let infoFirstPartLabel = UILabel()
    let infoSecondPartLabel = UILabel()
    
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
        addSubview(infoSecondPartLabel)
    }
    func configureView() {
        infoFirstPartLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                                   font: .santander(family: .micro,
                                                                    type: .regular,
                                                                    size: 14),
                                                   textAlignment: .left))
        infoSecondPartLabel.applyStyle(LabelStylist(textColor: .lisboaGray,
                                                   font: .santander(family: .micro,
                                                                    type: .regular,
                                                                    size: 14),
                                                   textAlignment: .left))
        backgroundColor = .paleYellow
        infoFirstPartLabel.numberOfLines = 0
        infoSecondPartLabel.numberOfLines = 0
        infoFirstPartLabel.text = "#Przelew na ZUS przy wykorzystaniu mechanizmu płatności podzielonej (Split Payment) jest realizowany z rachunku VAT powiązanego z wybranym rachunkiem rozliczeniowym."
        infoSecondPartLabel.text = "#W przypadku niewystarczających środków na rachunku VAT, brakujące środki zostaną pobrane z powiązanego rachunku rozliczeniowego."
    }
    func setUpLayout() {
        infoFirstPartLabel.translatesAutoresizingMaskIntoConstraints = false
        infoSecondPartLabel.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoFirstPartLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            infoFirstPartLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoFirstPartLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            infoSecondPartLabel.topAnchor.constraint(equalTo: infoFirstPartLabel.bottomAnchor, constant: 16),
            infoSecondPartLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoSecondPartLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoSecondPartLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
