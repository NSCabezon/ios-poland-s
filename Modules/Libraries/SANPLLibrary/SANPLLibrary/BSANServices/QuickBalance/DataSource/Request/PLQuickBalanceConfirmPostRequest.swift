struct PLQuickBalanceConfirmPostRequest: NetworkProviderRequest {
    let serviceName: String
    let serviceUrl: String
    let method: NetworkProviderMethod
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let jsonBody: [PLQuickBalanceConfirmParameterDTO]?
    let formData: Data?
    let bodyEncoding: NetworkProviderBodyEncoding?
    let contentType: NetworkProviderContentType?
    let localServiceName: PLLocalServiceName
    let authorization: NetworkProviderRequestAuthorization? = .oauth

    init(serviceName: String,
         serviceUrl: String,
         method: NetworkProviderMethod,
         body: Data? = nil,
         jsonBody: [PLQuickBalanceConfirmParameterDTO]? = nil,
         bodyEncoding: NetworkProviderBodyEncoding?,
         headers: [String: String]?,
         queryParams: [String: Any]? = nil,
         contentType: NetworkProviderContentType?,
         localServiceName: PLLocalServiceName) {
        self.serviceName = serviceName
        self.serviceUrl = serviceUrl
        self.method = method
        self.jsonBody = jsonBody
        self.formData = body
        self.headers = headers
        self.queryParams = queryParams
        self.contentType = contentType
        self.bodyEncoding = bodyEncoding
        self.localServiceName = localServiceName
    }
}
