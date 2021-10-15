import Foundation

public struct OnlineAdvisorUserContextParameters: Encodable {
    public let baseAddress: String
    public let msgTypeName: String
    public let productName: String
    public let messageSubject: String
    
    // TODO: Add sessionFeId [MOBILE-8612]
    
    public init(baseAddress: String, msgTypeName: String, productName: String, messageSubject: String) {
        self.baseAddress = baseAddress
        self.msgTypeName = msgTypeName
        self.productName = productName
        self.messageSubject = messageSubject
    }
}

/* TODO: Remove When request is finished
{
  "baseAddress": "https://doradca2.centrum24.pl/doradca-online/proxyserver/",
  "msgTypeName": "produktymobile",
  "productName": "A",
  "messageSubject": "produkt"
}
*/
