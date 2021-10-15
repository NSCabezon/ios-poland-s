
import UI

class UneditableFieldImageAccessoryView: UIView {
    private let imageView = UIImageView()
    private let image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UneditableFieldImageAccessoryView {
    func setUp() {
        addSubviews()
        prepareStyles()
        setUpLayout()
    }
    
    func addSubviews() {
        addSubview(imageView)
    }
    
    func prepareStyles() {
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .brownishGray
        imageView.contentMode = .scaleAspectFit
    }
    
    func setUpLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
