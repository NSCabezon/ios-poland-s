import Foundation

public struct PhoneVerificationDTO: Codable {
    public let aliases: [String]
    
    public init(aliases: [String]) {
        self.aliases = aliases
    }
}
