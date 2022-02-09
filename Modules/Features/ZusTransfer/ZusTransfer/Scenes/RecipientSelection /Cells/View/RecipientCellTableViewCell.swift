import UIKit

final class RecipientTableViewCell: UITableViewCell {
    static let identifier = String(describing: RecipientTableViewCell.self)
    private let nameLabel = UILabel()
    private let accountNumberLabel = UILabel()
    private let borderContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not supported")
    }
    
    func configure(with viewModel: RecipientCellViewModel) {
        nameLabel.text = viewModel.name
        accountNumberLabel.text = viewModel.accountNumber
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        accountNumberLabel.text = nil
    }
    
    private func setUp() {
        addSubviews()
        configureViews()
        setUpLayout()
    }
    
    private func addSubviews() {
        contentView.addSubview(borderContainerView)
        borderContainerView.translatesAutoresizingMaskIntoConstraints = false
        [nameLabel, accountNumberLabel].forEach {
            borderContainerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureViews() {
        selectionStyle = .none
        nameLabel.textColor = .lisboaGray
        nameLabel.font = .santander(
            family: .micro,
            type: .bold,
            size: 16
        )
        
        accountNumberLabel.textColor = .brownishGray
        accountNumberLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 14
        )
        
        borderContainerView.backgroundColor = .white
        borderContainerView.drawRoundedBorderAndShadow(
            with: .init(
                color: .lightSanGray,
                opacity: 0.5,
                radius: 4,
                withOffset: 0,
                heightOffset: 2
            ),
            cornerRadius: 5,
            borderColor: .mediumSkyGray,
            borderWith: 1
        )
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: borderContainerView.topAnchor, constant: 13),
            nameLabel.leadingAnchor.constraint(equalTo: borderContainerView.leadingAnchor, constant: 16),
            
            accountNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            accountNumberLabel.leadingAnchor.constraint(equalTo: borderContainerView.leadingAnchor, constant: 16),
            accountNumberLabel.bottomAnchor.constraint(lessThanOrEqualTo: borderContainerView.bottomAnchor, constant: -12),
            
            borderContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            borderContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            borderContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

