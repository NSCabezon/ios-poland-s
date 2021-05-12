import Foundation

public class BSANPLEnvironmentDTO: Hashable, Codable {
    
    public let isHttps: Bool
    public let name: String
    public let urlBase: String
    public let clientId: String
    public let urlNewRegistration: String
    
    public init(isHttps: Bool,
                name: String,
                urlBase: String,
                clientId: String,
                urlNewRegistration: String) {
        self.isHttps = isHttps
        self.name = name
        self.urlBase = urlBase
        self.clientId = clientId
        self.urlNewRegistration = urlNewRegistration
    }
    
    public var description: String {
        return "\(name) : \(urlBase)"
    }
    
    public var hashValue: Int {
        if let hash = Int(name) {
            return hash
        }
        return 0
    }
    
    public static func ==(lhs: BSANPLEnvironmentDTO, rhs: BSANPLEnvironmentDTO) -> Bool {
        return lhs.name == rhs.name
    }
}
