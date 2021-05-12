//
//  PLHostProvider.swift
//  SANPTLibrary
//
//  Created by Victor Carrilero García on 27/01/2021.
//

import Foundation

public protocol PLHostProviderProtocol {
    var environmentDefault: BSANPLEnvironmentDTO { get }
    func getEnvironments() -> [BSANPLEnvironmentDTO]
}
