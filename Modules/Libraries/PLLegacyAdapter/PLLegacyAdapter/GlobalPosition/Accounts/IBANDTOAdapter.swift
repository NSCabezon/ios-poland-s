//
//  IBANDTOAdapter.swift
//  PortugalLegacyAdapter
//

import SANLegacyLibrary

public final class IBANDTOAdapter {
    public class func adaptDisplayNumberToIBAN(_ displayNumber: String?) -> IBANDTO? {
        guard let displayNumber = displayNumber else {
            return nil
        }
        return IBANDTO(ibanString: displayNumber)
    }
}
