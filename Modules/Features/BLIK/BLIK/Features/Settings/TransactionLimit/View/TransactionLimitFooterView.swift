import UI
import Commons

final class TransactionLimitFooterView: UIView {
    var saveButtonTap: (() -> Void)?
    
    private let saveButton: RedLisboaButton = {
        let button = RedLisboaButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(localized("generic_button_save"), for: .normal)
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
    
    func setIsSaveButtonEnabled(_ isEnabled: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.saveButton.isEnabled = isEnabled
            self.saveButton.alpha = isEnabled ? 1 : 0.3
        }
    }
}

private extension TransactionLimitFooterView {
    func setUp() {
        addSubview(separatorView)
        addSubview(saveButton)
        
        saveButton.addAction { [weak self] in
            self?.saveButtonTap?()
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
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

