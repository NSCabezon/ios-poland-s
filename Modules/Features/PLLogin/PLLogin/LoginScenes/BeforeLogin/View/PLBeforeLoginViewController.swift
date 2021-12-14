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
    func imageReady()
    func loadStart()
}

final class PLBeforeLoginViewController: UIViewController {
    
    let dependenciesResolver: DependenciesResolver
    private let presenter: PLBeforeLoginPresenterProtocol
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var sanIconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loadingImageView: UIImageView!

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.loadStart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
}

private extension PLBeforeLoginViewController {
    
    func setNavigationBar() {
        NavigationBarBuilder(style: .clear(tintColor: .white), title: .none)
            .build(on: self, with: nil)
    }
    
    func setupViews() {
        backgroundImageView.backgroundColor = .black
        backgroundImageView.contentMode = .scaleAspectFill
        loadingImageView.setAnimationImagesWith(prefixName: "BS_", range: 1...154, format: "%03d")
    }
}

extension PLBeforeLoginViewController : PLBeforeLoginViewControllerProtocol {
    func imageReady() {
        self.backgroundImageView.image = TimeImageAndGreetingViewModel.shared.getBackground()
    }
    
    func loadDidFinish() {
        self.loadingImageView.stopAnimating()
        self.loadingImageView.isHidden = true
    }
    
    func loadStart() {
        self.loadingImageView.isHidden = false
        self.loadingImageView.startAnimating()
    }
    
    func showDeprecatedVersionDialog() {
        PLLoginCommonDialogs.presentDeprecatedVersionDialog(on: self) { [weak self] in
            self?.presenter.openAppStore()
        }
    }
}
