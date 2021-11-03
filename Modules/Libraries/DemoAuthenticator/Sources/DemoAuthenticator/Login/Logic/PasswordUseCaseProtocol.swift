//
//  PasswordUseCaseProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

protocol PasswordUseCaseProtocol {
    func mask(password: String, with mask: Int) -> String
}
