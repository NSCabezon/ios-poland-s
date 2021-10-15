//
//  ErrorResponseDecoding.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 22/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import Foundation

protocol ErrorResponseDecoding {
    func decode(data: Data) throws -> ErrorResponse
}
