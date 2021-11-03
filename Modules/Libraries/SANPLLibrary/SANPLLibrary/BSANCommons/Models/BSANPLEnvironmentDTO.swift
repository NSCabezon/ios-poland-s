//
//  BSANPLEnvironmentDTO.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

public class BSANPLEnvironmentDTO: Hashable, Codable {
    public let name: String
    public let urlBase: String
    public let blikAuthBaseUrl: String
    public let clientId: String

    public init(name: String, blikAuthBaseUrl: String, urlBase: String, clientId: String) {
        self.name = name
        self.urlBase = urlBase
        self.blikAuthBaseUrl = blikAuthBaseUrl
        self.clientId = clientId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
    
    public static func ==(lhs: BSANPLEnvironmentDTO, rhs: BSANPLEnvironmentDTO) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
