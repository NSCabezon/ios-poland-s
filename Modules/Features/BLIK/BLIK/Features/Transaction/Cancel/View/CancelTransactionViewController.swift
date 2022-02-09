import UI
import CoreFoundationLib
import PLCommons
import Foundation
import PLUI

protocol CancelTransactionViewProtocol: AnyObject {
}

final class CancelTransactionViewController: UIViewController, CancelTransactionViewProtocol {
    private let presenter: CancelTransactionPresenterProtocol
    
    private let imageView = UIImageView(image: Images.error)
    private let infoLabel = UILabel()
    private let bottomView = BottomButtonView(style: .white)
    
    init(presenter: CancelTransactionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setUp()
    }
}

private extension CancelTransactionViewController {
    @objc func goToGlobal() {
        presenter.goToGlobalPosition()
    }
    
    func setUp() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        prepareLayout()
        setIdentifiers()
    }

    func prepareNavigationBar() {
        NavigationBarBuilder(style: .custom(background: .color(.white), tintColor: .santanderRed),
                             title: .title(key: localized("pl_blik_title_cancTransac")))
            .setLeftAction(.back(action: #selector(goToGlobal)))
            .build(on: self, with: nil)

        navigationController?.addNavigationBarShadow()
    }
    
    func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(infoLabel)
        view.addSubview(bottomView)
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        infoLabel.configureText(
            withKey: presenter.cancelType.rawValue,
            andConfiguration: LocalizedStylableTextConfiguration(
                font: UIFont.santander(
                    family: .headline,
                    type: .bold,
                    size: 28
                ),
                alignment: .center,
                lineHeightMultiple: 1.2
            )
        )

        infoLabel.numberOfLines = 0

        bottomView.configure(title: localized("pl_blik_button_back")) { [weak self] in
            self?.goToGlobal()
        }
    }
    
    func prepareLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 44),
            imageView.heightAnchor.constraint(equalToConstant: 44),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setIdentifiers() {
        infoLabel.accessibilityIdentifier = AccessibilityBLIK.CancelTransaction.infoLabel.id
        imageView.accessibilityIdentifier = AccessibilityBLIK.CancelTransaction.imageView.id
    }
}
