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
        let htmlWithStyle = """
            <!DOCTYPE html>\
            <html>\
            <head>\
            <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\
            <meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'>\
            </head>\
            <body>\
            <p>\(html)</p>\
            <style>* { font-size: 14px; font-family: TrebuchetMS }</style>
            </body>\
            </html>
            """
        self.webView.loadHTMLString(htmlWithStyle, baseURL: Bundle.module?.bundleURL)
    }
    
    @objc func close() {
        presenter.didSelectClose()
    }
        
    func setup() {
        setupWebView()
        addSubviews()
        prepareStyles()
        prepareNavigationBar()
        prepareLayout()
    }
    
    func addSubviews() {
        view.addSubview(webView)
    }
    
    func prepareNavigationBar() {
        NavigationBarBuilder(style: .white, title: .title(key: localized("toolbar_title_notifications")))
            .setLeftAction(.back(action: #selector(close)))
            .build(on: self, with: nil)
        navigationController?.addNavigationBarShadow()
    }
    
    func prepareStyles() {
        view.backgroundColor = .white
    }
    
    func prepareLayout() {
        webView.frame = self.view.frame
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

