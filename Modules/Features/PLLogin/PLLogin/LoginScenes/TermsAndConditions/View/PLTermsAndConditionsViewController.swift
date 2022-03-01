//
//  PLTermsAndConditionsViewController.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 7/2/22.
//

import UI
import PLCommons
import CoreFoundationLib

protocol PLTermsAndConditionsViewProtocol: PLGenericErrorPresentableCapable {
    func dismissViewController()
}

final class PLTermsAndConditionsViewController: UIViewController {
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLTermsAndConditionsPresenterProtocol
    
    public var configuration: PLTermsAndConditionsConfiguration?

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var acceptButton: RedLisboaButton!
    @IBOutlet private weak var cancelButton: WhiteLisboaButton!
    @IBOutlet private weak var separatorView: UIView!

    private var sendTrackScrollView: Bool = false

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver, presenter: PLTermsAndConditionsPresenterProtocol) {
        self.presenter = presenter
        self.dependenciesResolver = dependenciesResolver
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        self.presenter.viewDidLoad()
        self.setupViews()
    }
}

private extension PLTermsAndConditionsViewController {
    func setupViews() {
        self.separatorView.backgroundColor = .mediumSky
        self.scrollView.delegate = self
        self.configureLabels()
        self.configureTextView()
        self.configureButtons()
        self.configureIds()
    }

    func configureLabels() {
        guard let title = configuration?.title else { return }
        let config = LocalizedStylableTextConfiguration(font: .santander(family: .text, type: .regular, size: 28))
        let localizedTitle: LocalizedStylableText = localized(title)
        self.titleLabel.configureText(withLocalizedString: localizedTitle, andConfiguration: config)
    }

    func configureTextView() {
        guard let description = configuration?.description else { return }
        let config = LocalizedStylableTextConfiguration(font: .santander(family: .text, type: .regular, size: 16))
        let localizedDescription: LocalizedStylableText = localized(description)
        self.descriptionTextView.configureText(withLocalizedString: localizedDescription, andConfiguration: config)
    }

    func configureButtons() {
        cancelButton.addAction {
            self.presenter.cancelButtonDidPressed()
        }
        acceptButton.addAction {
            self.presenter.acceptButtonDidPressed()
        }
        disableAcceptButton()

        acceptButton.setTitle(localized("generic_button_accept"), for: .normal)
        cancelButton.setTitle(localized("generic_button_cancel"), for: .normal)
    }
    
    func configureIds() {
        titleLabel.accessibilityIdentifier = PLTermsAndConditionsIdentifiers.title
        descriptionTextView.accessibilityIdentifier = PLTermsAndConditionsIdentifiers.text
        cancelButton.accessibilityIdentifier = PLTermsAndConditionsIdentifiers.cancelButton
        acceptButton.accessibilityIdentifier = PLTermsAndConditionsIdentifiers.acceptButton
    }

    func enableAcceptButton() {
        acceptButton.isEnabled = true
        acceptButton.backgroundColor = .santanderRed
        acceptButton.layer.borderColor = UIColor.santanderRed.cgColor
    }

    func disableAcceptButton() {
        acceptButton.isEnabled = false
        acceptButton.backgroundColor = .lightSanGray
        acceptButton.layer.borderColor = UIColor.lightSanGray.cgColor
    }

    func isScrollAtTheBottom() -> Bool {
        scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
    }
}

// MARK: UIScrollViewDelegate
extension PLTermsAndConditionsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrollAtTheBottom() {
            enableAcceptButton()
            guard self.sendTrackScrollView == false else { return }
            self.presenter.trackScrollDown()
            self.sendTrackScrollView = true
        }
    }
}

// MARK: TermsAndConditionsViewProtocol
extension PLTermsAndConditionsViewController: PLTermsAndConditionsViewProtocol {
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Accessibility identifier
extension PLTermsAndConditionsViewController {
    struct PLTermsAndConditionsIdentifiers {
        static let title = "T&CTitle"
        static let text = "T&CText"
        static let cancelButton = "T&CBtnCancel"
        static let acceptButton = "T&CBtnAccept"
    }
}
