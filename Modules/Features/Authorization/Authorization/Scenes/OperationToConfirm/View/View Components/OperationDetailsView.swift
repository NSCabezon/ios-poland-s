import PLUI
import UI
import CoreFoundationLib

final class OperationDetailsView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = localized("pl_mobileAuthorisation_label_details")
        label.numberOfLines = .zero
        let labelStylist = LabelStylist(textColor: .brownishGray,
                                        font: .santander(family: .micro, type: .regular, size: 12.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Przelew na rachunek: \n88 1223 3333 2221 0000 3232 8883, \nodbiorca: Jan Kowalski, tytuł: Opłata, \nkwota: 129,00 PLN"
        label.numberOfLines = .zero
        let labelStylist = LabelStylist(textColor: .lisboaGray,
                                        font: .santander(family: .micro, type: .bold, size: 14.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupSubviews()
        setupLayout()
        drawBorder(cornerRadius: 0, color: .mediumSkyGray, width: 1)
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11.0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.0)
        ])
    }
    
    func setup(with viewModel: String?) {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel
        descriptionLabel.text = viewModel
    }
}
