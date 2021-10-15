//
//  PubKeyEndpointProtocol.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 16/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

protocol PubKeyEndpointProtocol {
    func pubKey(
        authHost: URL,
        completion: @escaping (Result<PubKey, Swift.Error>) -> Void
    )
}
