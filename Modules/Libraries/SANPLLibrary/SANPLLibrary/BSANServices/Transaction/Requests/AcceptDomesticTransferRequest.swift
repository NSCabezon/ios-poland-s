import Foundation

struct AcceptDomesticTransferRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]? = nil
    let jsonBody: AcceptDomesticTransactionParameters?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?
    
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: AcceptDomesticTransactionParameters,
         bodyEncoding: NetworkProviderBodyEncoding? = .body,
         headers: [String: String]? = [:],
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType = .json,
         localServiceName: PLLocalServiceName = .authenticateInit,
         authorization: NetworkProviderRequestAuthorization? = .oauth
    ) {
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
