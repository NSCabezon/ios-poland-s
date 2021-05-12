import Foundation

public struct EcommerceConfirmWithAccessKeyDTO: Codable {
    public let state: String
    private enum CodingKeys: String, CodingKey {
        case state = "estado"
    }
}
