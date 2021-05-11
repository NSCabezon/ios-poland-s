//
//  Encodable.swift
//  SANPLLibrary
//
//  Created by Ernesto Fernandez Calles on 11/5/21.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    func getURLFormData() -> Data? {
        guard let dict = try? self.asDictionary() else { return nil }
        let jsonString = dict.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        return jsonString.data(using: .utf8, allowLossyConversion: false)
    }
    
    func getJsonData() -> Data? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return data
    }
}
