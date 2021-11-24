public struct DeviceData {
    public let manufacturer: String
    public let model: String
    public let brand: String
    public let appId: String
    public let deviceId: String
    public let deviceTime: String
    public let parameters: String
    
    public init(
        manufacturer: String,
        model: String,
        brand: String,
        appId: String,
        deviceId: String,
        deviceTime: String,
        parameters: String
    ) {
        self.manufacturer = manufacturer
        self.model = model
        self.brand = brand
        self.appId = appId
        self.deviceId = deviceId
        self.deviceTime = deviceTime
        self.parameters = parameters
    }
}
