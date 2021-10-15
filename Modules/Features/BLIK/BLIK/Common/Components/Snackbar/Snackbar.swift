import UIKit

class Snackbar: UIView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .santander(family: .text, type: .regular, size: 14)
        label.textColor = .lisboaGray
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = HStackView(
            [imageView, titleLabel],
            spacing: 16
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMessage(_ message: String, type: SnackbarType, completion: (() -> Void)? = nil) {
        imageView.image = type.image
        titleLabel.text = message
        
        layoutIfNeeded()
        let hiddenTransform = CGAffineTransform(translationX: 0, y: -frame.height)
        transform = hiddenTransform
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.transform = .identity
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.3, delay: 3, options: .curveEaseInOut) {
                self?.transform = hiddenTransform
            } completion: { _ in
                completion?()
            }

        }
    }
}

private extension Snackbar {
    func setup() {
        prepareSubviews()
        prepareStyles()
        prepareLayout()
    }
    
    func prepareSubviews() {
        addSubview(contentStack)
    }
    
    func prepareStyles() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.mediumSkyGray.cgColor
    }
    
    func prepareLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}

extension Snackbar {
    enum SnackbarType {
        case success
        case error
        
        var image: UIImage {
            switch self {
            case .success:
                return Images.ok
            case .error:
                return Images.error
            }
        }
    }
}
