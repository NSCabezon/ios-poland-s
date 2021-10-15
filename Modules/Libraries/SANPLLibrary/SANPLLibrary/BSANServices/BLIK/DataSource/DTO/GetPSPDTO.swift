import Foundation

public struct GetPSPDTO: Decodable {
    public let authCodeId: Int
    public let ticket: String
    public let ticketTime: Int
}
