//
//  HostsModule.swift
//  Santander
//
//  Created by Jose C. Yebes on 03/05/2021.
//

/// Note that this struct is maintained for compatibility with legacy code and will be removed in some point in the furure

import Foundation
import ESCommons
import SANLegacyLibrary
import SANLibraryV3

final class HostsModule: HostsModuleProtocol {
    func providesBSANHostProvider() -> BSANHostProviderProtocol {
        return BSANHostProviderEmpty()
    }
    
    func providesPublicFilesHostProvider() -> PublicFilesHostProviderProtocol {
        return PublicFilesHostProvider()
    }
    
    func providesMapPoiHostProvider() -> MapPoiHostProviderProtocol {
        return MapPoiHostProvider()
    }
}
