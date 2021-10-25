import UIKit
import UI
import PLUI
import Commons

struct AliasTransferContentViewModel {
    let text: String
}

final class AliasTransferView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    
    public init() {
        super.init(frame: .zero)
        configureSubviews()
        configureStyling()
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(viewModel: AliasTransferContentViewModel) {
        textLabel.text = viewModel.text
    }
}

private extension AliasTransferView {
    func configureContent() {
        titleLabel.text = "#Kupuj bez podawania kodu BLIK"
        imageView.image = Images.info_lisboaGray
    }
    
    func configureSubviews() {
        [imageView, titleLabel, textLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26),
            textLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    func configureStyling() {
        imageView.tintColor = .lisboaGray
        
        titleLabel.textColor = .lisboaGray
        titleLabel.font = .santander(
            family: .headline,
            type: .bold,
            size: 18
        )
        titleLabel.textAlignment = .center
        
        textLabel.textColor = .brownGray
        textLabel.font = .santander(
            family: .micro,
            type: .regular,
            size: 12
        )
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
    }
}
