//
//  LoginModelProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

protocol LoginModelProtocol {
    var authHost: URL { get }
    var nik: Int { get }
    var password: String { get }
}
