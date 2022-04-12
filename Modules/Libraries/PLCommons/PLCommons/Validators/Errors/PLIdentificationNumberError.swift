//
//  PLIdentificationNumberError.swift
//  PLCommons
//
//  Created by 189501 on 06/04/2022.
//

import Foundation

public enum PLIdentificationNumberError: Error {
    
    case invalidType
    // Throw when an invalid character entered
    case illegalCharacter
    // Throw when an invalid length of text entered
    case invalidLength
    // Throw when an identifier is empty
    case empty
    // Throw when check sum is invalid
    case invalidCheckSum

}
