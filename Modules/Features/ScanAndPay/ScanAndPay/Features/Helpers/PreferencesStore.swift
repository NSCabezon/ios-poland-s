//
//  PreferencesStore.swift
//  ScanAndPay
//
//  Created by 188216 on 23/03/2022.
//

import Foundation
import PLCommons

protocol PreferencesStoreProtocol {
    var isScannerShownForTheFirstTime: Bool { get set }
}

final class PreferencesStore: PreferencesStoreProtocol {
    enum Keys: String {
        case isScannerShownForTheFirstTime
        
        var string: String {
            return "scanAndPay.\(self.rawValue)"
        }
    }
    
    @DefaultsStorable(key: Keys.isScannerShownForTheFirstTime.string, defaultValue: true)
    var isScannerShownForTheFirstTime: Bool
}
