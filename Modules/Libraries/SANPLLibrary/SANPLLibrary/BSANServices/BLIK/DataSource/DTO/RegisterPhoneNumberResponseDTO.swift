//
//  RegisterPhoneNumberResponseDTO.swift
//  SANPLLibrary
//
//  Created by Piotr Mielcarzewicz on 24/08/2021.
//

public enum RegisterPhoneNumberResponseDTO: Decodable {
    case successfulyRegisteredPhoneNumber
    case smsAuthorizationCodeSent
    case error(Error)
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        guard let error = try? container.decode(Error.self) else {
            self = .successfulyRegisteredPhoneNumber
            return
        }
        
        if error.errorCode2 == 702 {
            self = .smsAuthorizationCodeSent
            return
        }
        
        self = .error(error)
    }
    
    public struct Error: Decodable {
        public let errorCode1: Int
        public let errorCode2: Int
        public let message: String
    }
    
    private enum CodingKeys: CodingKey {
        case errorCode1
        case errorCode2
        case message
    }
}
