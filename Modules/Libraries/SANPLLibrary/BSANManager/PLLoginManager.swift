//
//  PLLoginManager.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

public protocol PLLoginManagerProtocol {
    func doLoginWithNick(nick: String) throws -> Result<LoginDTO, Error>
}
