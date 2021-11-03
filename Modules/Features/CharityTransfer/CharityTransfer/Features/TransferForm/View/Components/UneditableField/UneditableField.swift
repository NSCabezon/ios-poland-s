
import UI

class UneditableField: UIView {
    
    enum RightAccessory {
        case image(UIImage?)
        case view(UIView)
        case none
    }
    
    private let fieldValueLabel = UILabel()
    private let mainStackView = UIStackView()
    private var rightAccessory: RightAccessory = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        fieldValueLabel.text = text
    }
    
    func setRightAccessoryView(_ rightAccessory: RightAccessory) {
        self.rightAccessory = rightAccessory
        setupRightAccessory()
    }
}

private extension UneditableField {
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(fieldValueLabel)
    }
    
    func prepareStyles() {
        backgroundColor = .lightSanGray
        
        mainStackView.axis = .horizontal
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.mediumSkyGray.cgColor
        fieldValueLabel.applyStyle(LabelStylist(textColor: .brownishGray,
                                                font: .santander(family: .micro,
                                                                 type: .regular,
                                                                 size: 16)))
    }
    
    func setUpLayout() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        fieldValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupRightAccessory() {
        switch rightAccessory {
        case .image(let image):
            let accessoryImageView = UneditableFieldImageAccessoryView(image: image)
            accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
            accessoryImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
            addVerticalSeparator()
            mainStackView.addArrangedSubview(accessoryImageView)
        case .view(let view):
            addVerticalSeparator()
            mainStackView.addArrangedSubview(view)
        case .none:
            return
        }
    }
    
    func addVerticalSeparator() {
        let verticalSeparator = UIView()
        verticalSeparator.backgroundColor = .brownishGray
        verticalSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        mainStackView.addArrangedSubview(verticalSeparator)
    }
}
