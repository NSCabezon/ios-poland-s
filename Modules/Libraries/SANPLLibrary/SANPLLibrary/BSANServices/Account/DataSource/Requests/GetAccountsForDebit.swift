import Foundation

struct GetAccountsForDebitRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: AuthenticateInitParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod = .get,
         body: Data? = nil,
         jsonBody: AuthenticateInitParameters? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .none,
         headers: [String: String]? = [:],
         contentType: NetworkProviderContentType? = .json,
         localServiceName: PLLocalServiceName = .accountForDebit,
         authorization: NetworkProviderRequestAuthorization? = .oauth) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.jsonBody = jsonBody
        self.bodyEncoding = bodyEncoding
        self.headers = headers
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}
