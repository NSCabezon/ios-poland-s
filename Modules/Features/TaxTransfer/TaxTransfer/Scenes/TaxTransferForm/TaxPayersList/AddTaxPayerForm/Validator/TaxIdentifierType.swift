//
//  TaxIdentifierType.swift
//  TaxTransfer
//
//  Created by 187831 on 04/02/2022.
//

import PLScenes
import CoreFoundationLib

enum TaxIdentifierType: SelectableItem {
    case NIP
    case PESEL
    case REGON
    case ID
    case passport
    case other
    
    public var identifier: String {
        return String(describing: self)
    }
    
    public var name: String {
        switch self {
        case .ID:
            return localized("pl_generic_docId_nationaIdentityCard")
        case .passport:
            return localized("pl_generic_docId_passport")
        case .other:
            return localized("pl_generic_docId_other")
        case .PESEL:
            return localized("pl_generic_docId_pesel")
        case .NIP:
            return localized("pl_generic_docId_nip")
        case .REGON:
            return localized("pl_generic_docId_regon")
        }
    }
    
    var complementValue: Int {
        return 10
    }

    var errorMessage: String {
        switch self {
        case .other:
            return localized("pl_taxTransfer_validation_forbiddenCharacter")
        case .NIP:
            return localized("pl_taxTransfer_validation_wrongNip")
        case .PESEL:
            return localized("pl_taxTransfer_validation_wrongPesel")
        case .REGON:
            return localized("pl_taxTransfer_validation_wrongRegon")
        case .ID:
            return localized("pl_taxTransfer_validation_wrongId")
        case .passport:
            return localized("pl_taxTransfer_validation_wrongPassport")
        }
    }
    
    var weights: [Int] {
        switch self {
        case .NIP:
            return TaxIdentifierWeights.nip
        case .PESEL:
            return TaxIdentifierWeights.pesel
        case .REGON:
            return TaxIdentifierWeights.regon
        case .ID:
            return TaxIdentifierWeights.personalId
        default:
            return []
        }
    }
    
    var regex: String {
        switch self {
        case .NIP:
            return "^\\d{10}$"
        case .REGON:
            return "^(\\d{9}|\\d{14})$"
        case .PESEL:
            return "^\\d{11}$"
        case .ID:
            return "^[A-Z]{3}\\d{6}$"
        case .passport:
            return "^([0-9A-Za-z\\-\\ ]{1,14})$"
        case .other:
            return "^([0-9A-Za-z????????????????????????????????????]{1,14})$"
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
    
    var length: Int? {
        switch self {
        case .PESEL:
            return 10
        case .NIP:
            return 9
        default:
            return nil
        }
    }
    
    var documentType: String {
        switch self {
        case .NIP:
            return "N"
        case .REGON:
            return "R"
        case .PESEL:
            return "P"
        case .ID:
            return "1"
        case .passport:
            return "2"
        case .other:
            return "3"
        }
    }
}
