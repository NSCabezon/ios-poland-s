//
//  PLWebviewCustomLinkHandler.swift
//  Santander

/**
    This is the Poland custom link handler.
    This handler be inyected in the webview presentation call when a webview requires Poland custom url actions (app://, santander://...).
 */
import Foundation
import CoreFoundationLib
import WebViews
import os

public class PLWebviewCustomLinkHandler: WebViewLinkHandler {
    public var configuration: WebViewConfiguration
    weak public var delegate: WebViewLinkHandlerDelegate?

    public required init(configuration: WebViewConfiguration) {
        self.configuration = configuration
    }

    private enum Constants {
        // Actions prefix
        static let plWebActionPrefix = "app://"
        static let santanderWebActionPrefix = "santander://"
        static let phoneWebActionPrefix = "tel:"
        static let mailWebActionPrefix = "mailto:"
        // keywords
        static let plOnlineAdvisorKeyWord = "openWD"
        static let plPdfKeyWord = "pdf"
        static let plHtmlKeyWord = "html"
        static let plCardHistoryKeyWord = "cardHistory"
        static let plCardListKeyWord = "cardList"
        static let plAccountHistoryKeyWord = "accountHistory"
        static let plSmsKeyWord = "sms"
    }

    private enum ActionType {
        case close
        case openOnlineAdvisor(params: String)
        case pdf(url: URL)
        case html(url: URL)
        case phone
        case email
        case sms(text: String)
        case deepLink(deepLink: DeepLink)
        case unknownAction
    }

    // MARK: WebViewLinkHandler protocol
    public func willHandle(url: URL?) -> Bool {
        guard let url = url else {
            return false
        }
        return isProcessableURL(url.absoluteString)
    }

    public func shouldLoad(request: URLRequest?, displayLoading: @escaping ((Bool) -> Void)) -> Bool {
        guard let urlString = request?.url?.absoluteString else {
            return false
        }
        let urlAction = getActionForURL(urlString)
        switch urlAction {
        case .phone:
            openPhone(url: request?.url)
            return false
        case .email:
            openEmail(url: request?.url)
            return false
        case .sms(let text):
            openSMSShareSheet(text: text)
            return false
        case .pdf(let url):
            openPDF(url: url)
            return false
        case .html(let url):
            openHtml(url: url)
            return false
        case .openOnlineAdvisor(let params):
            openOnlineAdvisor(params: params)
            return false
        default:
            return false
        }
    }
}

private extension PLWebviewCustomLinkHandler {

    func isProcessableURL(_ urlString: String) -> Bool {
        return urlString.hasPrefix(Constants.plWebActionPrefix)
            || urlString.hasPrefix(Constants.santanderWebActionPrefix)
            || urlString.hasPrefix(Constants.phoneWebActionPrefix)
            || urlString.hasPrefix(Constants.mailWebActionPrefix)
    }

    private func getActionForURL(_ urlString: String) -> ActionType {
        switch urlString {
        case _ where urlString.hasPrefix(Constants.plWebActionPrefix):
            switch urlString {
            case _ where urlString.contains(Constants.plOnlineAdvisorKeyWord):
                guard let params = getOnlineAdvisorParams(urlString: urlString) else {
                    return .unknownAction
                }
                return .openOnlineAdvisor(params: params)
            case _ where urlString.contains(Constants.plPdfKeyWord):
                guard let pdfUrl = getPdfUrl(urlString: urlString) else {
                    return .unknownAction
                }
                return .pdf(url: pdfUrl)
            case _ where urlString.contains(Constants.plHtmlKeyWord):
                guard let htmlUrl = getHtmlUrl(urlString: urlString) else {
                    return .unknownAction
                }
                return .html(url: htmlUrl)
            case _ where urlString.contains(Constants.plCardHistoryKeyWord):
                guard let vpan = getQueryStringParameter(url: urlString, param: "vpan") else {
                    return .unknownAction
                }
                os_log("✅ [PLLINKHANDLER] Detected card history action with vpan: %@", log: .default, type: .info, vpan)
                return .unknownAction
            case _ where urlString.contains(Constants.plCardListKeyWord):
                os_log("✅ [PLLINKHANDLER] Detected card list action", log: .default, type: .info)
                return .unknownAction
            case _ where urlString.contains(Constants.plAccountHistoryKeyWord):
                guard let accountId = getQueryStringParameter(url: urlString, param: "accountId") else {
                    return .unknownAction
                }
                os_log("✅ [PLLINKHANDLER] Detected account history action with account id: %@", log: .default, type: .info, accountId)
                return .unknownAction
            case _ where urlString.contains(Constants.plSmsKeyWord):
                guard let message = getQueryStringParameter(url: urlString, param: "message") else {
                    return .unknownAction
                }
                return .sms(text: message)
            default:
                return .unknownAction
            }
        case _ where urlString.hasPrefix(Constants.santanderWebActionPrefix):
            return .unknownAction
        case _ where urlString.hasPrefix(Constants.phoneWebActionPrefix):
            return .phone
        case _ where urlString.hasPrefix(Constants.mailWebActionPrefix):
            return .email
        default:
            return .unknownAction
        }
    }

    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }

    func getPdfUrl(urlString: String) -> URL? {
        let prefix = Constants.plWebActionPrefix + Constants.plPdfKeyWord + "/"
        guard urlString.hasPrefix(prefix) else { return nil }
        return URL(string: String(urlString.dropFirst(prefix.count)))
    }
    
    func getHtmlUrl(urlString: String) -> URL? {
        let prefix = Constants.plWebActionPrefix + Constants.plHtmlKeyWord + "/"
        guard urlString.hasPrefix(prefix) else { return nil }
        return URL(string: String(urlString.dropFirst(prefix.count)))
    }
    
    func getOnlineAdvisorParams(urlString: String) -> String? {
        let prefix = Constants.plWebActionPrefix + Constants.plOnlineAdvisorKeyWord + "/"
        guard urlString.hasPrefix(prefix) else { return nil }
        return String(urlString.dropFirst(prefix.count))
    }

    // MARK: Actions impl
    func openEmail(url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }

    func openPhone(url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }

    func openSMSShareSheet(text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }

    func openPDF(url: URL) {
        // Get PDF data: note that this is a orientative simple implementation
        let pdfData = try? Data.init(contentsOf: url)

        // Ask delegate to show it
        if let pdfData = pdfData {
            delegate?.displayPDF(with: pdfData)
        }
    }

    func openDeepLink(deeplink: DeepLink) {
        delegate?.open(deepLink: deeplink)
    }
    
    func openHtml(url: URL?) {
        guard let url = url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }        
    }
    
    func openOnlineAdvisor(params: String) {
        let deeplink = DeepLink.custom(deeplink: "onlineAdvisor", userInfo: [DeepLinkUserInfoKeys.date: params])
        delegate?.open(deepLink: deeplink)
    }
    
}
