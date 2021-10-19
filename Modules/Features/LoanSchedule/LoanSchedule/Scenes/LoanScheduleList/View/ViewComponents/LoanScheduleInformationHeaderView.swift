import Commons
import PLUI
import UI

private enum Constants {
    static let messageTextFont = UIFont.santander(family: .micro, type: .regular, size: 14.0)
}

final class LoanScheduleInformationHeaderView: UITableViewHeaderFooterView {
    public static var identifier = "PLLoanScheduleInformationHeaderView"
    
    private let containerView = UIView()
    private let iconView = UIImageView()
    private let messageLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        setUpSubviews()
        setUpLayout()
        setUpIconView()
        setUpMessageLabel()
        setUpContainerView()
    }
    
    private func setUpSubviews() {
        addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(iconView)
    }
    
    private func setUpLayout() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
            
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 19),
            messageLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 18),
            messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -17),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -17)
        ])
    }
    
    private func setUpIconView() {
        iconView.image = UIImage(named: "bankBranchIcon", in: .module, compatibleWith: nil)
    }
    
    private func setUpMessageLabel() {
        messageLabel.font = Constants.messageTextFont
        messageLabel.textColor = .lisboaGray
        messageLabel.numberOfLines = 0
        messageLabel.text = localized("pl_loanSchedule_label_loanScheduleInfo")
    }
    
    private func setUpContainerView() {
        containerView.backgroundColor = .paleYellow
    }
}
