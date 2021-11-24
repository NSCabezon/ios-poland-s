//
//  AuthorizeOperationDTO.swift
//  SANPLLibrary
//
//  Created by Adrian Arcalá Ocón on 10/11/21.
//

import Foundation
import CoreDomain

struct AuthorizeOperationDTO: RedirectUriRepresentable {
    let uri: String
}
