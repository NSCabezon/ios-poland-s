//
//  Demo.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

public struct DemoMode : Codable {
    
    public let demoUser: String
    
    init(_ demoUser: String) {
        self.demoUser = demoUser
    }
}
