import Commons
import PLUI
import UI

private enum Constants {
    static let backgroundColor: UIColor = .clear
    static let containerColor: UIColor = UIColor(red: 233.0 / 255.0, green: 243.0 / 255.0, blue: 247 / 255.0, alpha: 1.0)
    // TODO: Move colors to the separate module
    
    static let titleTextColor = UIColor(red: 109.0 / 255.0, green: 114.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
    static let titleTextFont = UIFont.santander(family: .text, type: .regular, size: 14.0)
    
    static let roundCornerRadius: CGFloat = 4.0
}

final class HelpCenterInfoCell: UITableViewCell {
    public static var identifier = "HelpCenterInfoCell"
        
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let cellImageView = UIImageView()
    
    // MARK: - Initialisation
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - Private methods
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setCellImage(_ image: UIImage?) {
        cellImageView.image = image
    }
    
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpView() {
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(cellImageView)
        
        backgroundColor = Constants.backgroundColor
        containerView.backgroundColor = Constants.containerColor
        
        containerView.drawBorder(cornerRadius: Constants.roundCornerRadius, color: .clear, width: 0)
    }
    
    private func setUpSubviews() {
        setUpTitleLabel()
        setCellUpImageView()
    }
        
    private func setUpLayouts() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20.0),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20.0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            
            cellImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 1),
            cellImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 13.0),
            cellImageView.heightAnchor.constraint(equalToConstant: 24.0),
            cellImageView.widthAnchor.constraint(equalToConstant: 24.0),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14.0),
            titleLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 13.0),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -22.0),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14.0),
        ])
    }
    
    private func setUpTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.applyStyle(LabelStylist(textColor: Constants.titleTextColor, font: Constants.titleTextFont, textAlignment: .left))
    }
    
    private func setCellUpImageView() {
        cellImageView.contentMode = .scaleAspectFit
        cellImageView.backgroundColor = .clear
    }
}

extension HelpCenterInfoCell: ElementViewModelSetUpable {
    func setUp(with viewModel: HelpCenterElementViewModel) {
        setTitle(viewModel.element.title)
        if case let .local(image: image) = viewModel.element.icon {
            setCellImage(image)
        }
    }
}
