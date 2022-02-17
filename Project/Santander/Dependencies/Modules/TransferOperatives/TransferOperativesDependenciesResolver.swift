//
//  TransferOperativesDependenciesResolver.swift
//  Santander
//
//  Created by Cristobal Ramos Laina on 17/2/22.
//

import Foundation
import TransferOperatives

extension ModuleDependencies: TransferOperativesExternalDependenciesResolver {
    func resolve() -> InternalTransferPreSetupUseCase {
        return PLInternalTransferPreSetupUseCase(dependencies: self)
    }
}
