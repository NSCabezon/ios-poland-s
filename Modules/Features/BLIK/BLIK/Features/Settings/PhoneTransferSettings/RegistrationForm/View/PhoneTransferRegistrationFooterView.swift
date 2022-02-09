import UI
import CoreFoundationLib

final class PhoneTransferRegistrationFooterView: UIView {
    var registerButtonTap: (() -> Void)?
    
    private let registerButton: RedLisboaButton = {
        let button = RedLisboaButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(localized("pl_blik_button_registerNumb"), for: .normal)
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
}

private extension PhoneTransferRegistrationFooterView {
    func setUp() {
        addSubview(separatorView)
        addSubview(registerButton)
        
        registerButton.addAction { [weak self] in
            self?.registerButtonTap?()
        }
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            registerButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            registerButton.heightAnchor.constraint(equalToConstant: 48),
            registerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
