import Foundation

public struct OnlineAdvisorUserContextParameters: Encodable {
    public let baseAddress: String
    public let msgTypeName: String
    public let productName: String
    public let messageSubject: String

    public init(baseAddress: String, msgTypeName: String, productName: String, messageSubject: String) {
        self.baseAddress = baseAddress
        self.msgTypeName = msgTypeName
        self.productName = productName
        self.messageSubject = messageSubject
    }
}
