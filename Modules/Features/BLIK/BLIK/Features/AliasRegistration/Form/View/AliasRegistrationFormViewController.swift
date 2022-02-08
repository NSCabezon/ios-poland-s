import Operative
import UI
import CoreFoundationLib
import UIKit
import PLUI
import PLCommons

protocol AliasRegistrationFormViewProtocol: LoaderPresentable, ErrorPresentable {
    func set(viewModel: AliasRegistrationFormContentViewModel)
}

final class AliasRegistrationFormViewController: UIViewController, AliasRegistrationFormViewProtocol {
    private let presenter: AliasRegistrationFormPresenterProtocol
    
    private let contentView = AliasRegistrationFormView()
    private let footerView = AliasRegistrationFormFooterView()
    
    init(
        presenter: AliasRegistrationFormPresenterProtocol
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
        presenter.viewDidLoad()
        setUp()
    }
    
    func set(viewModel: AliasRegistrationFormContentViewModel) {
        contentView.set(viewModel: viewModel)
    }
}

private extension AliasRegistrationFormViewController {
    func setUp() {
        configureNavigationItem()
        configureSubviews()
        configureStyling()
        configureFooterView()
    }
    
    func configureSubviews() {
        view.addSubview(contentView)
        view.addSubview(footerView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            footerView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureStyling() {
        view.backgroundColor = .white
    }
    
    func configureNavigationItem() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_text_withoutCode")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func configureFooterView() {
        footerView.configureActions(onSaveButtonTap: presenter.didPressSave,
                                    onRejectButtonTap: presenter.goToGlobalPosition)
    }
    
    @objc func close() {
        presenter.didPressClose()
    }
}
