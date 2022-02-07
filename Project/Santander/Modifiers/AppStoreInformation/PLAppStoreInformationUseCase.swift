//
//  PLAppStoreInformationUseCase.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 24/1/22.
//

import Foundation
import RetailLegacy
import CoreFoundationLib
import PLCommons

final class PLAppStoreInformationUseCase: UseCase<Void, AppStoreInformationUseCaseOkOutput, StringErrorOutput>, AppStoreInformationUseCase {
    override func executeUseCase(requestValues: Void) throws -> UseCaseResponse<AppStoreInformationUseCaseOkOutput, StringErrorOutput> {
        let info = AppStoreInformationUseCaseOkOutput(storeId: PLConstants.appStoreId)
        return .ok(info)
    }
}
