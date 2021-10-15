//
//  BundleFile.swift
//  CreditCardRepayment_Tests
//
//  Created by 186490 on 13/07/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DecodeFile<DataType: Decodable> {
    let name: String
    let type: FileType
    let bundle: Bundle
    private let decoder: FileDecoder
    private let fileManager: FileManager = .default
    
    public init(name: String, type: FileType = .json, bundle: Bundle) {
        self.name = name
        self.type = type
        self.decoder = type.decoder
        self.bundle = bundle
    }
    
    public var wrappedValue: DataType {
        guard let path = bundle.path(forResource: name, ofType: type.rawValue) else { fatalError("Resource not found") }
        guard let data = fileManager.contents(atPath: path) else { fatalError("File not loaded") }
        return try! decoder.decode(DataType.self, from: data)
    }
}

public extension DecodeFile {
    enum FileType: String {
        case json
    }
}

fileprivate extension DecodeFile.FileType {
    var decoder: FileDecoder {
        switch self {
        case .json: return JSONDecoder()
        }
    }
}

fileprivate protocol FileDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: FileDecoder {}
