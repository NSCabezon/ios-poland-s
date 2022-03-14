import UI
import CoreFoundationLib
import PLCommons
import Foundation
import PLUI

protocol CancelTransactionViewProtocol: AnyObject, ErrorPresentable, LoaderPresentable {}

final class CancelTransactionViewController: UIViewController, CancelTransactionViewProtocol {
    private let presenter: CancelTransactionPresenterProtocol
    private let viewModel: CancelTransactionViewModel
    
    private let imageView = UIImageView(image: Images.error)
    private let infoLabel = UILabel()
    
    private let singleBottomButton = BottomButtonView(style: .white)
    private let dualBottomButtons = BottomDualButtonView(firstButtonStyle: .red, secondButtonStyle: .white)
    
    init(presenter: CancelTransactionPresenterProtocol) {
        self.presenter = presenter
        self.viewModel = presenter.getViewModel()
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
    func setUp() {
        prepareStyles()
        prepareNavigationBar()
        prepareLayout()
        setIdentifiers()
    }

    func prepareNavigationBar() {
        NavigationBarBuilder(style: .custom(background: .color(.white), tintColor: .santanderRed),
                             title: .title(key: localized("pl_blik_title_cancTransac")))
            .setLeftAction(.back(action: .selector(#selector(didTapBack))))
            .build(on: self, with: nil)

        navigationController?.addNavigationBarShadow()
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        infoLabel.configureText(
            withKey: viewModel.infoLabelLocalizationKey,
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
    }
    
    func prepareLayout() {
        let bottomView: UIView = {
            switch viewModel.bottomButtonsArrangement {
            case .onlyBackButton:
                dualBottomButtons.isHidden = true
                singleBottomButton.isHidden = false
                prepareBackButton()
                return singleBottomButton
            case let .backAndDeleteAliasButtons(deleteAliasText):
                dualBottomButtons.isHidden = false
                singleBottomButton.isHidden = true
                prepareBackAndDeleteAliasButtons(with: deleteAliasText)
                return dualBottomButtons
            }
        }()
        
        [
            imageView,
            infoLabel,
            bottomView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func prepareBackButton() {
        singleBottomButton.configure(title: localized("pl_blik_button_back")) { [weak self] in
            self?.presenter.didPressBack()
        }
    }
    
    func prepareBackAndDeleteAliasButtons(with deleteAliasText: String) {
        let deleteAliasViewModel = BottomButtonViewModel(title: deleteAliasText) { [weak self] in
            self?.presenter.didPressDeleteAlias()
        }
        let backButtonViewModel = BottomButtonViewModel(title: localized("pl_blik_button_back")) { [weak self] in
            self?.presenter.didPressBack()
        }
        
        dualBottomButtons.configure(
            firstButtonViewModel: deleteAliasViewModel,
            secondButtonViewModel: backButtonViewModel
        )
    }
    
    func setIdentifiers() {
        infoLabel.accessibilityIdentifier = AccessibilityBLIK.CancelTransaction.infoLabel.id
        imageView.accessibilityIdentifier = AccessibilityBLIK.CancelTransaction.imageView.id
    }
    
    @objc func didTapBack() {
        presenter.didPressBack()
    }
}
