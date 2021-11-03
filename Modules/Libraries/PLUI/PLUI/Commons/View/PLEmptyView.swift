import Commons
import UI

private enum Constants {
    static let backgroundColor: UIColor = .white
    
    static let titleTextColor = UIColor.lisboaGray
    static let titleTextFont = UIFont.santander(family: .micro, type: .bold, size: 18)
    
    static let messageTextColor = UIColor.lisboaGray
    static let messageTextFont = UIFont.santander(family: .micro, type: .regular, size: 14.0)

    static let backgroundMessageColor = UIColor.paleYellow
}

public final class PLEmptyView: UIView {
    private let verticalStackView = UIStackView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let backgroundImageView = UIImageView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    public func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    public func setMessageText(_ text: String) {
        messageLabel.text = text
    }
}

private extension PLEmptyView {
    private func setUp() {
        backgroundColor = Constants.backgroundColor
        
        setUpSubviews()
        setUpLayout()
        setUpBackgroundImageView()
        setUpVerticalStackView()
        setUpTitleLabel()
        setUpMessageLabel()
    }
    
    private func setUpSubviews() {
        addSubview(backgroundImageView)
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(messageLabel)
    }
    
    private func setUpLayout() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor, constant: 130),
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 167),
            verticalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 56),
            verticalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -56),
        ])
    }
    
    private func setUpBackgroundImageView() {
        backgroundImageView.image = PLAssets.image(named: "leavesEmpty")
        backgroundImageView.contentMode = .scaleAspectFit
    }
    
    private func setUpVerticalStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 0
    }
    
    private func setUpTitleLabel() {
        titleLabel.font = Constants.titleTextFont
        titleLabel.textColor = Constants.titleTextColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    private func setUpMessageLabel() {
        messageLabel.font = Constants.messageTextFont
        messageLabel.textColor = Constants.messageTextColor
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
    }
}
