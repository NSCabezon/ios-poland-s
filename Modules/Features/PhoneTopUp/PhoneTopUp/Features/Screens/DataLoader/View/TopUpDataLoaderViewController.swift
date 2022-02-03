//
//  TopUpDataLoaderViewController.swift
//  PhoneTopUp
//
//  Created by 188216 on 01/02/2022.
//

import Commons
import Operative
import UI
import PLUI
import PLCommons

protocol TopUpDataLoaderViewProtocol: AnyObject, LoaderPresentable, ErrorPresentable {
}

final class TopUpDataLoaderViewController: UIViewController {
    // MARK: Properties
    
    private let presenter: TopUpDataLoaderPresenterProtocol
    
    // MARK: Lifecycle
    
    init(presenter: TopUpDataLoaderPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.viewDidLoad()
    }
    
    // MARK: Configuration
    
    private func setUp() {
        prepareNavigationBar()
        prepareStyles()
    }
    
    private func prepareNavigationBar() {
        NavigationBarBuilder(style: .white,
                             title: .title(key: localized("pl_topup_title_topup")))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    private func prepareStyles() {
        view.backgroundColor = .white
    }
}

extension TopUpDataLoaderViewController: TopUpDataLoaderViewProtocol {
}
