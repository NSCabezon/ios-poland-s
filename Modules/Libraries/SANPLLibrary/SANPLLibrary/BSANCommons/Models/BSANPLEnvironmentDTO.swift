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

    public init(name: String, urlBase: String) {
        self.name = name
        self.urlBase = urlBase
    }
    
    public var hashValue: Int {
        if let hash = Int(name) {
            return hash
        }
        return 0
    }
    
    public static func ==(lhs: BSANPLEnvironmentDTO, rhs: BSANPLEnvironmentDTO) -> Bool {
        return lhs.name == rhs.name
    }
}
