import PLUI
import UI

final class OperationDetails3DSecureView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Płatność kartą"
        label.numberOfLines = .zero
        let labelStylist = LabelStylist(textColor: .brownishGray,
                                        font: .santander(family: .micro, type: .semibold, size: 12.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    private var cardNumber: UILabel = {
        let label = UILabel()
        label.text = "MasterCard ****3467"
        label.numberOfLines = .zero
        let labelStylist = LabelStylist(textColor: .lisboaGray,
                                        font: .santander(family: .micro, type: .bold, size: 14.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    private var cardImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "card", in: .module, compatibleWith: nil)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .redGraphic
        return imageView
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Szczegóły operacji"
        label.numberOfLines = .zero
        let labelStylist = LabelStylist(textColor: .brownishGray,
                                        font: .santander(family: .micro, type: .semibold, size: 12.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
        return label
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Płatności: 31-03-2021 21:37 \nkwota: 22.00 EUR \nsklep: Nazwa Sklepu"
        label.numberOfLines = .zero
        let labelStylist = LabelStylist(textColor: .lisboaGray,
                                        font: .santander(family: .micro, type: .bold, size: 14.0),
                                        textAlignment: .left)
        label.applyStyle(labelStylist)
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
        addSubview(cardImageView)
        addSubview(descriptionLabel)
        addSubview(cardNumber)
        addSubview(contentLabel)
    }
    
    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNumber.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11.0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            titleLabel.rightAnchor.constraint(equalTo: cardImageView.leftAnchor, constant: -16.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            cardImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24.0),
            cardImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10.0),
            cardImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18.0),
            cardImageView.heightAnchor.constraint(equalToConstant: 27.0),
            cardImageView.widthAnchor.constraint(equalToConstant: 116.0),
                        
            cardNumber.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
            cardNumber.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            cardNumber.rightAnchor.constraint(equalTo: cardImageView.leftAnchor, constant: -16.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: 25.0),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),

            contentLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5.0),
            contentLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            contentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.0)
        ])
    }
}
