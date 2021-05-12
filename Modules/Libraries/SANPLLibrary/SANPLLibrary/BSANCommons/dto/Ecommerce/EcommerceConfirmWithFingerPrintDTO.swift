import Foundation

public struct EcommerceConfirmWithFingerPrintDTO: Codable {
    public let state: String
    private enum CodingKeys: String, CodingKey {
        case state = "estado"
    }
}
