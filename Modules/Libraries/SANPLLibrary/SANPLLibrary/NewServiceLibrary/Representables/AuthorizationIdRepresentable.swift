//
//  AuthorizationIdRepresentable.swift
//  SANPLLibrary
//
//  Created by Carlos Monfort Gómez on 4/11/21.
//

import CoreDomain

public protocol AuthorizationIdRepresentable {
    var authorizationId: String? { get }
}
