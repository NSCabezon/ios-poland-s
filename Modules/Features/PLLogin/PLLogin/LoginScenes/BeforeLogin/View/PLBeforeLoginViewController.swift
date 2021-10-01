//
//  PLBeforeLoginViewController.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 27/9/21.
//

import Foundation
import PLCommons
import Commons
import UI

protocol PLBeforeLoginViewControllerProtocol: PLGenericErrorPresentableCapable {
    func showDeprecatedVersionDialog()
    func loadDidFinish()
    func loadStart()
}

final class PLBeforeLoginViewController: UIViewController {
    
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLBeforeLoginPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loadingImage: UIImageView!

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, dependenciesResolver: DependenciesResolver,
         presenter: PLBeforeLoginPresenterProtocol) {
        self.presenter = presenter
        self.dependenciesResolver = dependenciesResolver
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.presenter.viewDidLoad()
        self.loadingImage.setPointsLoader()
        self.loadingImage.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadingImage.isHidden = false
        presenter.viewDidAppear()
    }
}

private extension PLBeforeLoginViewController {
    
    func setNavigationBar() {
        NavigationBarBuilder(style: .clear(tintColor: .white), title: .none)
            .build(on: self, with: nil)
    }
    
    func setupViews() {
        let timeImageAndGreeting = TimeImageAndGreetingViewModel()
        sanIconImageView?.image = Assets.image(named: "icnSanWhiteLisboa")
        backgroundImageView.image = timeImageAndGreeting.backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        
        titleLabel.font = .santander(family: .text, type: .light, size: 40)
        titleLabel.textColor = UIColor.Legacy.uiWhite
        titleLabel.text = localized(timeImageAndGreeting.greetingTextKey.rawValue)
    }
}

extension PLBeforeLoginViewController : PLBeforeLoginViewControllerProtocol {
    func loadDidFinish() {
        self.loadingImage.isHidden = true
    }
    
    func loadStart() {
        self.loadingImage.isHidden = false
    }
    
    func showDeprecatedVersionDialog() {
        PLLoginCommonDialogs.presentDeprecatedVersionDialog(on: self) { [weak self] in
            self?.presenter.openAppStore()
        }
    }
}
