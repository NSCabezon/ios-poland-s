//
//  RegisterPhoneNumberRequestDTO.swift
//  SANPLLibrary
//
//  Created by Piotr Mielcarzewicz on 24/08/2021.
//

public struct RegisterPhoneNumberRequestDTO: Codable {
    public let accountNo: String
    public let authCode: String?
    
    public init(
        accountNo: String,
        authCode: String?
    ) {
        self.accountNo = accountNo
        self.authCode = authCode
    }
}
