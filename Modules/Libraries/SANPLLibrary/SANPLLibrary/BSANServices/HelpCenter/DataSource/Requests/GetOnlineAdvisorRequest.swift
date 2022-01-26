import Foundation

struct GetOnlineAdvisorRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: NetworkProviderRequestBodyEmpty? = nil
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization?
    
    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: Encodable? = nil,
         bodyEncoding: NetworkProviderBodyEncoding? = .form,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName,
         authorization: NetworkProviderRequestAuthorization? = nil
    ) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.formData = body
        self.bodyEncoding = bodyEncoding
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.localServiceName = localServiceName
        self.authorization = authorization
    }
}
