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
    @IBOutlet private weak var loadingView: UIView!
    
    var loadingInfo: LoadingInfo!

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

private extension PLBeforeLoginViewController {
    
    func setNavigationBar() {
        NavigationBarBuilder(style: .clear(tintColor: .white), title: .none)
            .build(on: self, with: nil)
    }
    
    func setupViews() {
        backgroundImageView.image = TimeImageAndGreetingViewModel.shared.backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        
        let inset = self.backgroundImageView.center.y 
        self.loadingInfo = LoadingInfo(type: .onView(view: self.loadingView,
                                                     frame: self.loadingView.bounds,
                                                     position: .center,
                                                     controller: self),
                                       loadingText: LoadingText(title: LocalizedStylableText(text: "", styles: nil)),
                                       placeholders: nil,
                                       topInset: Double(inset),
                                       background: .clear,
                                       loadingImageType: .spin,
                                       style: .onView)
    }
}

extension PLBeforeLoginViewController : PLBeforeLoginViewControllerProtocol {
    func loadDidFinish() {
        self.backgroundImageView.image = TimeImageAndGreetingViewModel.shared.backgroundImage
        self.dismissLoading()
    }
    
    func loadStart() {
        self.showLoadingWithLoading(info: self.loadingInfo)
    }
    
    func showDeprecatedVersionDialog() {
        PLLoginCommonDialogs.presentDeprecatedVersionDialog(on: self) { [weak self] in
            self?.presenter.openAppStore()
        }
    }
}
