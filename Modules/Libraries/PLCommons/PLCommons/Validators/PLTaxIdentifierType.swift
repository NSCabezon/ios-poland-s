//
//  PLTaxIdentifierType.swift
//  PLCommons
//
//  Created by 187831 on 05/04/2022.
//


public enum PLTaxIdentifierType {
    case NIP
    case PESEL
    case REGON
    case ID
    case passport
    case other
    
    var identifier: String {
        return String(describing: self)
    }
    
    var name: String {
        switch self {
        case .ID:
            return "#Dowód osobisty"
        case .passport:
            return "#Paszport"
        case .other:
            return "#Inny"
        case .PESEL:
            return "#PESEL"
        case .NIP:
            return "#NIP"
        case .REGON:
            return "#REGON"
        }
    }
    
    var complementValue: Int {
        return 10
    }
    
    var errorMessage: String {
        switch self {
        case .other:
            return "#Wprowadzony tekst zawiera niedozwolone znaki"
        default:
            return "#Błędny numer \(self.name)"
        }
    }
    
    var weights: [Int] {
        switch self {
        case .NIP:
            return PLTaxIdentifierWeights.nip
        case .PESEL:
            return PLTaxIdentifierWeights.pesel
        case .REGON:
            return PLTaxIdentifierWeights.regon
        case .ID:
            return PLTaxIdentifierWeights.personalId
        default:
            return []
        }
    }
    
    var regex: String {
        switch self {
        case .NIP:
            return "^\\d+$"
        case .REGON:
            return "^(\\d{9}|\\d{14})$"
        case .PESEL:
            return "^\\d{11}$"
        case .ID:
            return "^[A-Z]{3}\\d{6}$"
        case .passport:
            return "^([0-9A-Za-z\\-\\ ]{1,14})$"
        case .other:
            return "^([0-9A-Za-ząęćółńśżźĄĘĆÓŁŃŚŻŹ]{1,14})$"
        }
    }
    
    var moduloValue: Int? {
        switch self {
        case .PESEL:
            return 10
        case .NIP:
            return 11
        default:
            return nil
        }
    }
    
    var isComplementValue: Bool? {
        switch self {
        case .PESEL:
            return true
        case .NIP:
            return false
        default:
            return nil
        }
    }
    
    var checksumIndex: Int? {
        switch self {
        case .PESEL:
            return 10
        case .NIP:
            return 9
        default:
            return nil
        }
    }
    
    var lengthWithoutControlSum: Int? {
        switch self {
        case .PESEL:
            return 10
        case .NIP:
            return 9
        default:
            return nil
        }
    }
    
    public var length: Int? {
        switch self {
        case .PESEL:
            return 11
        case .NIP:
            return 10
        default:
            return nil
        }
    }
}
