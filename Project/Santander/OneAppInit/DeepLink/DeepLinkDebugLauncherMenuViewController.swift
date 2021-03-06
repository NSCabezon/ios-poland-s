//
//  DeepLinkDebugLauncherMenuViewController.swift
//  Santander
//
//  Created by 186493 on 01/10/2021.
//

import Foundation
import UIKit
import UI
import CoreFoundationLib

final class DeepLinkDebugLauncherMenuViewController: UIViewController {
    
    private weak var delegate: DeepLinkDebugLauncherMenuCoordinatorDelegate?
    private let deepLinks: [DeepLinkEnumerationCapable]
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    init(deepLinks: [DeepLinkEnumerationCapable], delegate: DeepLinkDebugLauncherMenuCoordinatorDelegate?) {
        self.deepLinks = deepLinks
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpView()
        setUpSubviews()
        setUpLayouts()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setUpSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        deepLinks.forEach { deepLink in
            let button = RedLisboaButton()
            button.labelButtonLines(numberOfLines: 2)
            button.setTextAligment(.center, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            
            button.addAction { [weak self] in
                self?.delegate?.selectDeepLink(deepLink)
            }
            button.setTitle(deepLink.deepLinkKey, for: .normal)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setUpLayouts() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        NavigationBarBuilder(style: .sky,
                             title: .title(key: "DeepLink register"))
            .setLeftAction(.back(action: #selector(didSelectBack)))
            .build(on: self, with: nil)
    }
    
    @objc private func didSelectBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
