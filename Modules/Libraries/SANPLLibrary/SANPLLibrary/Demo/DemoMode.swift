//
//  DemoMode.swift
//  SANPTLibrary
//
//  Created by Luis Escámez Sánchez on 17/03/2021.
//

import Foundation

public struct DemoMode : Codable {
    
    public let demoUser: String
    
    init(_ demoUser: String) {
        self.demoUser = demoUser
    }
}
