//
//  AuthorizationDTO.swift
//  SANPLLibrary
//
//  Created by Carlos Monfort Gómez on 5/11/21.
//

import CoreDomain

struct AuthorizationIdDTO: Codable {
    let authorizationId: String?
}

extension AuthorizationIdDTO: AuthorizationIdRepresentable {}
