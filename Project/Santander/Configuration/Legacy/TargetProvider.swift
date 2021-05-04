import SANLibraryV3
import Alamofire
import RetailLegacy
import ESCommons

final class TargetProvider: TargetProviderProtocol {
    let alamofireManager: SessionManager
    let webServicesUrlProvider: WebServicesUrlProvider
    private let bsanDataProvider: BSANDataProvider
    private let demoInterpreter: DemoInterpreter
    
    init(webServicesUrlProvider: WebServicesUrlProvider, bsanDataProvider: BSANDataProvider) {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        self.alamofireManager = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: .production
        )
        self.webServicesUrlProvider = webServicesUrlProvider
        self.bsanDataProvider = bsanDataProvider
        self.demoInterpreter = DemoInterpreterImpl(bsanDataProvider: bsanDataProvider, defaultDemoUser: "")
    }

    func getDemoInterpreter() -> DemoInterpreter {
        return demoInterpreter
    }
    
    func getSoapCallExecutorProvider() -> SoapServiceExecutor {
        return AlamoExecutor(alamofireManager)
    }
    
    func getRestCallExecutorProvider() -> RestServiceExecutor {
        return RestAlamoExecutor(alamofireManager, webServicesUrlProvider: webServicesUrlProvider, bsanDataProvider: bsanDataProvider)
    }

    func getSoapDemoExecutorProvider() -> SoapServiceExecutor? {
        return nil
    }
    
    func getRestCallJsonExecutorProvider() -> RestServiceExecutor {
        return RestJSONAlamoExecutor(alamofireManager, webServicesUrlProvider: webServicesUrlProvider, bsanDataProvider: bsanDataProvider)
    }

    func getRestDemoExecutorProvider() -> RestServiceExecutor? {
        return nil
    }
}
