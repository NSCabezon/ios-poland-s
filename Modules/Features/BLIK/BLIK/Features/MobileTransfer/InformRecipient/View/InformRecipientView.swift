import UI

class InformRecipientView: UIShareView {
    
    let sharedContainer = UIView()
    private let borderedContainer = UIView()
    private let icon = UIImageView(image: Assets.image(named: "icnSantander"))
    private let header = UILabel()
    private let stackView = UIStackView()
    private let tornImageView = UIImageView(image: Assets.image(named: "imgTornSummary"))

    private let viewModel: InformRecipientViewModel

    init(viewModel: InformRecipientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundleName: nil)
        setUp()
        view.backgroundColor = .clear
        sharedContainer.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InformRecipientView {
    func setUp() {
        addSubviews()
        prepareStyle()
        prepareLayout()
        prepareData()
    }
    
    func addSubviews() {
        view.addSubview(sharedContainer)
        sharedContainer.addSubview(borderedContainer)
        sharedContainer.addSubview(tornImageView)
        [icon, header, stackView]
            .forEach { borderedContainer.addSubview($0) }
    }
    
    func prepareData() {
        header.text = viewModel.header
        let views = viewModel.listViewModel.map { InformRecipientInfoItem(viewModel: $0) }
        views.forEach { stackView.addArrangedSubview($0) }
    }

    func prepareStyle() {
        borderedContainer.backgroundColor = .white
        borderedContainer.drawBorder(cornerRadius: 0, color: .mediumSky, width: 1)

        header.font = .santander(family: .micro, type: .regular, size: 16)
        header.numberOfLines = 0
        header.textColor = .brownishGray
        
        icon.contentMode = .scaleAspectFit

        stackView.axis = .vertical
    }
    
    func prepareLayout() {
        [sharedContainer, borderedContainer, icon, header, stackView, tornImageView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        header.setContentHuggingPriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate([
            sharedContainer.topAnchor.constraint(equalTo: view.topAnchor),
            sharedContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sharedContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sharedContainer.heightAnchor.constraint(equalToConstant: 630),
    
            borderedContainer.topAnchor.constraint(equalTo: sharedContainer.topAnchor, constant: 19),
            borderedContainer.leadingAnchor.constraint(equalTo: sharedContainer.leadingAnchor, constant: 16),
            borderedContainer.trailingAnchor.constraint(equalTo: sharedContainer.trailingAnchor, constant: -16),
            
            icon.topAnchor.constraint(equalTo: borderedContainer.topAnchor, constant: 23),
            icon.leadingAnchor.constraint(equalTo: borderedContainer.leadingAnchor, constant: 19),
            icon.widthAnchor.constraint(equalToConstant: 131),
            icon.heightAnchor.constraint(equalToConstant: 23),
            
            header.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 26),
            header.leadingAnchor.constraint(equalTo: borderedContainer.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: borderedContainer.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 9),
            stackView.leadingAnchor.constraint(equalTo: borderedContainer.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: borderedContainer.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: borderedContainer.bottomAnchor),
        
            tornImageView.topAnchor.constraint(equalTo: borderedContainer.bottomAnchor, constant: -2),
            tornImageView.leadingAnchor.constraint(equalTo: borderedContainer.leadingAnchor),
            tornImageView.trailingAnchor.constraint(equalTo: borderedContainer.trailingAnchor),
            tornImageView.bottomAnchor.constraint(equalTo: sharedContainer.bottomAnchor, constant: -19),
            tornImageView.heightAnchor.constraint(equalToConstant: 23)
        ])
    }
}

