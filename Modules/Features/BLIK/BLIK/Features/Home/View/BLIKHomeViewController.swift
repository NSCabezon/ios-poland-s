//
//  BLIKHomeViewController.swift
//  Pods
//
//  Created by 186488 on 31/05/2021.
//  

import UI
import CoreFoundationLib
import Foundation
import PLUI
import PLCommons
import PLHelpCenter

protocol BLIKHomeViewProtocol: SnackbarPresentable, ErrorPresentable, LoaderPresentable, DialogViewPresentationCapable {
    func setMenuItems(_ viewModels: [BLIKMenuViewModel])
    
    func startProgressAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval)
    func updateCounter(remainingSeconds: Int)
        
    func setCode(_ code: String)
    func enableGenerateNewCode()
    func hideCodeComponent()
}

final class BLIKHomeViewController: UIViewController {
    private let dependenciesResolver: DependenciesResolver
    private let presenter: BLIKHomePresenterProtocol
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let blikView = BLIKView()
    private let menuView = BLIKMenuView()

    init(dependenciesResolver: DependenciesResolver, presenter: BLIKHomePresenterProtocol) {
        self.dependenciesResolver = dependenciesResolver
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setup()
        blikView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.addNavigationBarShadow()
        presenter.viewWillAppear()
        let onlineAdvisor = self.dependenciesResolver.resolve(for: PLOnlineAdvisorManagerProtocol.self)
        onlineAdvisor.pauseScreenSharing()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let onlineAdvisor = self.dependenciesResolver.resolve(for: PLOnlineAdvisorManagerProtocol.self)
        onlineAdvisor.resumeScreenSharing()
    }
}

extension BLIKHomeViewController: BLIKHomeViewProtocol {
    func setMenuItems(_ viewModels: [BLIKMenuViewModel]) {
        menuView.setItems(viewModels)
    }
    
    func setCode(_ code: String) {
        blikView.setCode(code)
        blikView.isHidden = false
    }
    
    func startProgressAnimation(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        blikView.startProgressBarAnimation(totalDuration: totalDuration, remainingDuration: remainingDuration)
        blikView.setRemainingSeconds(Int(remainingDuration))
        
        blikView.isAllHidden = false
        blikView.isGenerateButtonHidden = true
    }
    
    func updateCounter(remainingSeconds: Int) {
        blikView.setRemainingSeconds(remainingSeconds)
    }
    
    func enableGenerateNewCode() {
        blikView.isGenerateButtonHidden = false
    }
    
    func hideCodeComponent() {
        blikView.isAllHidden = true
        blikView.isGenerateButtonHidden = false
    }
}

private extension BLIKHomeViewController {
    @objc
    func close() {
        presenter.didSelectClose()
    }
    
    func setup() {
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        prepareActions()
        prepareLayout()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(blikView)
        stackView.addArrangedSubview(menuView)
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("pl_blik_title_blikCode")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 18, left: 18, bottom: 18, right: 18)
    }
    
    func prepareActions() {
        blikView.onCopyTapped = { [weak self] code in
            self?.presenter.didSelectCopyCode(code)
        }
        
        blikView.onGenerateTapped = { [weak self] in
            self?.presenter.didSelectGenerate()
        }
        
        menuView.onItemTapped = { [weak self] item in
            self?.presenter.didSelectMenuItem(item.item)
        }
    }
    
    func prepareLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
}
