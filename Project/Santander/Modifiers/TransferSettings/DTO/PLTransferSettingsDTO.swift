
import Foundation

struct PLTransferSettingsDTO: Codable {
    let charityTransfer: PLCharityTransferSettingsDTO?
    let topup: [PLTopUpTransferSettingsDTO]

    private enum CodingKeys: String, CodingKey {
        case charityTransfer = "charity_transfer"
        case topup
    }
}
