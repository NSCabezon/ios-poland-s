//
//  PLCharacterSet.swift
//  PLCommons
//
//  Created by 185167 on 26/04/2022.
//

import Foundation

public extension CharacterSet {
    static var ascii: CharacterSet {
        return CharacterSet(charactersIn: String(Array(0...127).map { Character(Unicode.Scalar($0)) }))
    }
    
    static var polishLetters: CharacterSet {
        return CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyząęćółńśżźĄĘĆÓŁŃŚŻŹ")
    }
}
