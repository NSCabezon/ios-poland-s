
import Foundation

struct PLTransferSettingsDTO: Codable {
    let charityTransfer: PLCharityTransferSettingsDTO?

    private enum CodingKeys: String, CodingKey {
        case charityTransfer = "charity_transfer"
    }
}
