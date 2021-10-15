//
//  PasswordUseCase.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation
import Security

final class PasswordUseCase {}

extension PasswordUseCase: PasswordUseCaseProtocol {
    func mask(password: String, with mask: Int) -> String {
        var maskedPassword = ""
        for (index, character) in password.enumerated() {
            if mask & (1 << index) != 0 {
                maskedPassword.append(character)
            }
        }
        return maskedPassword
    }
}
