import CoreFoundationLib
import CoreFoundationLib

public struct BasePLWebConfiguration: WebViewConfiguration {
    public var initialURL: String
    public var httpMethod: HTTPMethodType
    public var headers: [String: String]?
    public var bodyParameters: [String: String]?
    public var closingURLs: [String]
    public var webToolbarTitleKey: String?
    public var pdfToolbarTitleKey: String?
    public var engine: WebViewConfigurationEngine
    public var pdfSource: PdfSource?
    public var isCachePdfEnabled: Bool
    public var isFullScreenEnabled: Bool?
    public var reloadSessionOnClose: Bool
    
    public init(
        initialURL: String,
        httpMethod: HTTPMethodType = .post,
        headers: [String: String]? = nil,
        bodyParameters: [String: String]?,
        closingURLs: [String],
        webToolbarTitleKey: String?,
        pdfToolbarTitleKey: String?,
        engine: WebViewConfigurationEngine = .webkit,
        pdfSource: PdfSource? = nil,
        isCachePdfEnabled: Bool = false,
        isFullScreenEnabled: Bool?,
        reloadSessionOnClose: Bool = false
    ) {
        self.initialURL = initialURL
        self.httpMethod = httpMethod
        self.headers = headers
        self.bodyParameters = bodyParameters
        self.closingURLs = closingURLs
        self.webToolbarTitleKey = webToolbarTitleKey
        self.pdfToolbarTitleKey = pdfToolbarTitleKey
        self.engine = engine
        self.pdfSource = pdfSource
        self.isCachePdfEnabled = isCachePdfEnabled
        self.isFullScreenEnabled = isFullScreenEnabled
        self.reloadSessionOnClose = reloadSessionOnClose
    }
}
