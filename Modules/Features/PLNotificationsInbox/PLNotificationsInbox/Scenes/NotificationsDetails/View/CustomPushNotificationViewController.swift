//
//  CustomPushNotificationViewController.swift
//  Santander
//
//  Created by 188418 on 28/12/2021.
//

import UIKit
import WebKit
import UI
import CoreFoundationLib

protocol CustomPushNotificationViewProtocol: AnyObject {
    func openHtml(_ html: String)
}

class CustomPushNotificationViewController: UIViewController, WKUIDelegate {
    private let presenter: CustomPushNotificationPresenterProtocol
    private let webView = WKWebView()
    private let closeButton = LisboaButton()
    init(presenter: CustomPushNotificationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }   
}

extension CustomPushNotificationViewController: CustomPushNotificationViewProtocol {
   
    func openHtml(_ html: String) {
        self.webView.loadHTMLString(html, baseURL: nil)
    }
    
    @objc func close() {
        presenter.didSelectClose()
    }
        
    func setup() {
        setupWebView()
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        prepareActions()
        prepareLayout()
    }
    
    func addSubviews() {
        view.addSubview(webView)
        view.addSubview(closeButton)
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("toolbar_title_notifications")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
        closeButton.configureAsRedButton()
        closeButton.setTitle(localized("pl_alerts_button_close"), for: .normal)
    }
    
    func prepareActions() {
        closeButton.addAction { [weak self] in
            self?.close()
        }
    }
    
    func prepareLayout() {
        webView.frame = self.view.frame
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -17)
        ])
    }
    
    private func setupWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}

extension CustomPushNotificationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard let urlString = navigationAction.request.url?.absoluteString.lowercased() else {
            return
        }
        
        if urlString.hasPrefix("santander://") {
            print(urlString)
            //TODO: Create deep link form string
//            presenter.selectDeepLink(DeepLink.)
            
        }
    }
}

