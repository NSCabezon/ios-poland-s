
import Foundation

struct PLTransferSettingsDTO: Codable {
    let charityTransfer: PLCharityTransferSettingsDTO?
    let topup: [PLTopUpTransferSettingsDTO]
    let zusTransfer: PLZusTransferSettingsDTO?

    private enum CodingKeys: String, CodingKey {
        case charityTransfer = "charity_transfer"
        case topup
        case zusTransfer = "zus_transfer"
    }
}
