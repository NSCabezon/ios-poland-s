//
//  SessionData.swift
//  SANPLLibrary
//

import Foundation

public class SessionData: Codable {
    
    public var loggedUserDTO: UserDTO
    public var globalPositionDTO: GlobalPositionDTO?

    public init(_ userDTO: UserDTO) {
        self.loggedUserDTO = userDTO
    }
    
    public func updateSessionData(_ isPB: Bool) {
        loggedUserDTO.isPB = isPB
    }
    
    public func updateSessionData(_ globalPositionDTO: GlobalPositionDTO) {
        self.globalPositionDTO = globalPositionDTO
    }
    
}
