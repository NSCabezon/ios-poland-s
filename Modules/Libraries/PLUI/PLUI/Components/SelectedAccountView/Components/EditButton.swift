import UI

public final class EditButton: UIView {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let overviewButton = UIButton()
    private var buttonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(image: UIImage?, name: String, action: @escaping () -> Void) {
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        nameLabel.text = name
        buttonAction = action
    }
}

private extension EditButton {
    
    @objc func buttonTapHandle() {
        self.buttonAction?()
    }
    
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(nameLabel)
        addSubview(imageView)
        addSubview(overviewButton)
    }
    
    func prepareStyles() {
        overviewButton.addTarget(self, action: #selector(buttonTapHandle), for: .touchUpInside)
        nameLabel.applyStyle(LabelStylist(textColor: .darkTorquoise,
                                          font: .santander(family: .micro,
                                                           type: .bold,
                                                           size: 14),
                                          textAlignment: .center))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkTorquoise
    }
    
    func setUpLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor),
            
            overviewButton.topAnchor.constraint(equalTo: topAnchor),
            overviewButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            overviewButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            overviewButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
