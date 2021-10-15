import Foundation

public struct OnlineAdvisorDTO: Codable {
    
    public let checkInterval: String
    public let messages: [String: String]
    public let servicesBaseAddress: String
    public let iconBaseAddress: String
    public let channels: [Channel]
    public let orderProductOnlineAdvisor: OrderProductOnlineAdvisor
    
    enum CodingKeys: String, CodingKey {
        case checkInterval = "check-interval"
        case messages = "messages"
        case servicesBaseAddress = "services-base-address"
        case iconBaseAddress = "icon-base-address"
        case channels = "channels"
        case orderProductOnlineAdvisor = "order-product-online-advisor"
    }
}

public extension OnlineAdvisorDTO {
    
    struct Channel: Codable {
        public let profiles: [HelpCenterClientProfile]
        public let channelName: String
        public let mediumType: MediumType
        public let iconName: String
        public let subjects: [Subject]
        
        enum CodingKeys: String, CodingKey {
            case profiles = "profiles"
            case channelName = "channel-name"
            case mediumType = "medium-type"
            case subjects = "subjects"
            case iconName = "ico"
        }
    }
    
    struct Subject: Codable {
        public let name: String
        public let entryType: String
        public let subjectId: String
        public let requiredLoggingIn: Bool?
        public let iconName: String
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case entryType = "entry-type"
            case subjectId = "subject-id"
            case requiredLoggingIn = "required-logging-in"
            case iconName = "ico"
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decode(String.self, forKey: .name)
            entryType = try values.decode(String.self, forKey: .entryType)
            subjectId = try values.decode(String.self, forKey: .subjectId)
            if let stringValue = try values.decodeIfPresent(String.self, forKey: .requiredLoggingIn),
               let boolValue = Bool(stringValue) {
                requiredLoggingIn = boolValue
            } else {
                requiredLoggingIn = nil
            }
            iconName = try values.decode(String.self, forKey: .iconName)
        }
    }
    
    struct OrderProductOnlineAdvisor: Codable {
        public let individual: OrderProductOnlineAdvisorDetails
        public let corporate: OrderProductOnlineAdvisorDetails
    }
    
    struct OrderProductOnlineAdvisorDetails: Codable {
        public let entryType: String
        public let subjectId: String
        public let mediumType: MediumType
        
        enum CodingKeys: String, CodingKey {
            case entryType = "entry-type"
            case subjectId = "subject-id"
            case mediumType = "medium-type"
        }
    }

    enum MediumType: String, Codable {
        case video = "V"
        case audio = "A"
        case chat = "C"
    }
}
