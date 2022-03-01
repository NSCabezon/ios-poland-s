//
//  PLTermsAndConditionsDTO.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 3/2/22.
//

import Foundation

public struct PLTermsAndConditionsDTO: Codable {
    public let version: Int
    public let title: String
    public let description: String

    private enum CodingKeys: String, CodingKey {
        case version = "version"
        case title = "title"
        case description = "description"
    }
}
