import UI
import Commons
import PLUI

protocol SmsConfirmationView: AnyObject, LoaderPresentable, ErrorPresentable {}

final class SmsConfirmationViewController: UIViewController, SmsConfirmationView {
    private let smsLabel = UILabel()
    private let smsTextField = LisboaTextField()
    private let okButton = RedLisboaButton()
    
    private let presenter: SmsConfirmationPresenterProtocol
    
    init(
        presenter: SmsConfirmationPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not compatbile with truth and beauty!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension SmsConfirmationViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureTexts()
        configureTargets()
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: "#Rejestracja 2/2"))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
    
    func configureSubviews() {
        view.addSubview(smsLabel)
        view.addSubview(smsTextField)
        view.addSubview(okButton)
        
        smsLabel.translatesAutoresizingMaskIntoConstraints = false
        smsTextField.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            smsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            smsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            smsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            smsTextField.topAnchor.constraint(equalTo: smsLabel.bottomAnchor, constant: 8),
            smsTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            smsTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            smsTextField.heightAnchor.constraint(equalToConstant: 40),
            
            okButton.heightAnchor.constraint(equalToConstant: 48),
            okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
        okButton.isEnabled = false
        smsLabel.textColor = .lisboaGray
        smsLabel.font = .santander(
            family: .text,
            type: .regular,
            size: 14
        )
        smsTextField.updatableDelegate = self
        smsTextField.setEditingStyle(
            .writable(
                configuration: .init(
                    type: .floatingTitle,
                    formatter: nil,
                    disabledActions: [],
                    keyboardReturnAction: nil,
                    textFieldDelegate: nil,
                    textfieldCustomizationBlock: { components in
                        components.textField.keyboardType = .decimalPad
                    }
                )
            )
        )
    }
    
    func configureTexts() {
        smsLabel.text = "#Kod SMS:"
        okButton.setTitle("#OK", for: .normal)
    }
    
    func configureTargets() {
        okButton.addAction { [weak self] in
            guard
                let strongSelf = self,
                let authCode = strongSelf.smsTextField.text
            else {
                return
            }
            strongSelf.presenter.didPressSubmit(withCode: authCode)
        }
    }
}
extension SmsConfirmationViewController: UpdatableTextFieldDelegate {
    func updatableTextFieldDidUpdate() {
        okButton.isEnabled = !(smsTextField.text ?? "").isEmpty
    }
}
