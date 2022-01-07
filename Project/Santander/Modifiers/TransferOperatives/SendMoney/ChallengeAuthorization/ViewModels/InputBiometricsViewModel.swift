//
//  InputBiometricsViewModel.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 10/11/21.
//

import CoreFoundationLib

public final class InputBiometricsViewModel {
    let biometryType: BiometryTypeEntity
        
    public init(biometryType: BiometryTypeEntity) {
        self.biometryType = biometryType
    }
}
