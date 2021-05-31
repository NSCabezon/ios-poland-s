//
//  SessionData.swift
//  SANPLLibrary
//

import Foundation

public class SessionData: Codable {
    
    var loggedUserDTO: UserDTO
    var globalPositionDTO: GlobalPositionDTO?

    init(_ userDTO: UserDTO) {
        self.loggedUserDTO = userDTO
    }
    
    func updateSessionData(_ isPB: Bool) {
        loggedUserDTO.isPB = isPB
    }
    
    func updateSessionData(_ globalPositionDTO: GlobalPositionDTO) {
        self.globalPositionDTO = globalPositionDTO
    }
    
}
