//
//  DashboardViewController.swift
//  mCommerce
//
//

import UI
import Commons
import Foundation

protocol DashboardViewProtocol: GenericErrorDialogPresentationCapable, LoadingViewPresentationCapable {
    func showErrorDialog()
}

final class DashboardViewController: UIViewController {
    private let presenter: DashboardPresenterProtocol
    private lazy var contentView = DashboardView()
    
    init(presenter: DashboardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: "#mCommerce")) // Proper title is set by presenter
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }

}

extension DashboardViewController: DashboardViewProtocol {
    
    func showErrorDialog() {
        //Handle error dialog here
    }
}

private extension DashboardViewController {
    
    @objc func didSelectBack() {
        presenter.backButtonSelected()
    }
}

