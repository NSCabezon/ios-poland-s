import UI
import Commons

final class AliasRegistrationFormFooterView: UIView {
    private var onSaveButtonTap: (() -> Void)?
    private var onRejectButtonTap: (() -> Void)?
    
    private let saveButton: RedLisboaButton = {
        let button = RedLisboaButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("#Zapamiętaj", for: .normal)
        return button
    }()
    
    private let rejectButton: WhiteLisboaButton = {
        let button = WhiteLisboaButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("#Nie, dziękuję", for: .normal)
        return button
    }()
    
    private let separatorView: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .mediumSkyGray
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureActions(
        onSaveButtonTap: @escaping () -> Void,
        onRejectButtonTap: @escaping () -> Void
    ) {
        self.onSaveButtonTap = onSaveButtonTap
        self.onRejectButtonTap = onRejectButtonTap
    }
    
    func setIsSaveButtonEnabled(_ isEnabled: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.saveButton.isEnabled = isEnabled
            self.saveButton.alpha = isEnabled ? 1 : 0.3
        }
    }
}

private extension AliasRegistrationFormFooterView {
    func setUp() {
        addSubview(separatorView)
        addSubview(saveButton)
        addSubview(rejectButton)
        
        saveButton.addAction { [weak self] in
            self?.onSaveButtonTap?()
        }
        
        rejectButton.addAction { [weak self] in
            self?.onRejectButtonTap?()
        }
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            
            rejectButton.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
            rejectButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            rejectButton.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            rejectButton.heightAnchor.constraint(equalToConstant: 48),
            rejectButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
