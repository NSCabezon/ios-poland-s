//
//  PLPushStatusResponseEntity.swift
//  SANPLLibrary
//
//  Created by 188418 on 15/02/2022.
//

public struct PLPushStatusResponseEntity {
    public var code: String?
    public var message: String?
    
    public init(_ dto: PLPushStatusResponseDTO) {
        code = dto.code
        message = dto.message
    }
}
