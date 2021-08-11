//
//  DevicesDTO.swift
//  SANPLLibrary
//
//  Created by Mario Rosales Maillo on 3/8/21.
//

import Foundation

public struct DevicesDTO: Codable {
    public let defaultAuthorizationType: AuthorizationType
    public let allowedAuthorizationTypes: [AuthorizationType]
    public let availableAuthorizationTypes: [AuthorizationType]
}
