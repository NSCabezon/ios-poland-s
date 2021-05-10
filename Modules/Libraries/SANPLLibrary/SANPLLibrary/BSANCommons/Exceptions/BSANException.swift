//
//  BSANException.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 10/5/21.
//

import Foundation

open class BSANException: Error, Codable {

    var message: String?
    public var url: String?

    public init(_ message: String, url: String? = nil) {
        self.message = message
        self.url = url
    }

    public var localizedDescription: String {
        return message ?? ""
    }

}
