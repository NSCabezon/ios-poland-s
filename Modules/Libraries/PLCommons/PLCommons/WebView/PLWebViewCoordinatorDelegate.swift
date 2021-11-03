import Foundation
import WebViews

public protocol PLWebViewCoordinatorDelegate: AnyObject {
    func showWebView(handler: WebViewLinkHandler)
    func closedWebView(url: URL)
}
