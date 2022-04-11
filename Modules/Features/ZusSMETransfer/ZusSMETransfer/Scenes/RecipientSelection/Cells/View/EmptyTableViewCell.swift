import UIKit
import UI
import CoreFoundationLib
import PLCommons
import PLUI

final class EmptyTableViewCell: UITableViewCell {
    static let identifier = String(describing: EmptyTableViewCell.self)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let backgroundImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not supported")
    }
    
    func configure(with viewModel: EmptyCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.attributedText = getAttributedMessageText(from: viewModel.description)
    }
    
    private func setUp() {
        addSubviews()
        configureViews()
        setUpLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.attributedText = nil
    }
    
    private func addSubviews() {
        [backgroundImage, titleLabel, descriptionLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureViews() {
        titleLabel.font = .santander(family: .headline, type: .bold,size: 18)
        titleLabel.textAlignment = .center
        selectionStyle = .none
        backgroundImage.image = PLAssets.image(named: "leavesEmpty") ?? UIImage()
        titleLabel.textColor = .lisboaGray
        descriptionLabel.numberOfLines = 0
   
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            backgroundImage.heightAnchor.constraint(equalToConstant: 140),
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 68),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func getAttributedMessageText(from text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4
        
        return NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.lisboaGray,
                .font: UIFont.santander(
                    family: .micro,
                    type: .regular,
                    size: 12
                ),
                .paragraphStyle: paragraphStyle
            ]
        )
    }
}
