//
//  IBANDTOAdapter.swift
//  PLLegacyAdapter
//

import SANLegacyLibrary

final class IBANDTOAdapter {
    static func adaptDisplayNumberToIBAN(_ displayNumber: String?) -> IBANDTO? {
        guard let displayNumber = displayNumber else {
            return nil
        }
        return IBANDTO(ibanString: displayNumber)
    }
}
