//
//  TaxSymbolDTO.swift
//  SANPLLibrary
//
//  Created by 185167 on 15/03/2022.
//

public struct TaxSymbolDTO: Decodable, Equatable {
    public let dateFrom: String
    public let dateTo: String?
    public let symbol: String
    public let type: Int
    public let active: Bool
    public let isTimePeriodRequired: Bool
    public let isFundedFromVatAccount: Bool
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dateFrom = try container.decode(String.self, forKey: .dateFrom)
        dateTo = try? container.decode(String.self, forKey: .dateTo)
        symbol = try container.decode(String.self, forKey: .symbol)
        type = try container.decode(Int.self, forKey: .type)
        active = try container.decode(Bool.self, forKey: .active)
        
        if let options = try? container.decode([TaxSymbolOption].self, forKey: .options) {
            isTimePeriodRequired = options.contains(.timePeriodRequired)
            isFundedFromVatAccount = options.contains(.fundsFromVatAccount)
        } else {
            isTimePeriodRequired = false
            isFundedFromVatAccount = false
        }
    }
    
    private enum TaxSymbolOption: String, Equatable, Codable {
        case timePeriodRequired = "TIME_PERIOD_REQUIRED"
        case fundsFromVatAccount = "FUNDS_FROM_VAT_ACCOUNT"
    }
    
    private enum CodingKeys: String, CodingKey {
        case dateFrom
        case dateTo
        case symbol
        case type
        case active
        case options
    }
}
