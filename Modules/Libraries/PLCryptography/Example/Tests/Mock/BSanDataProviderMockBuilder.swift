//
//  BSanDataProviderMockBuilder.swift
//  PLCryptography_Tests
//
//  Created by 187830 on 17/11/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import CoreFoundationLib
import Repository
import SANLegacyLibrary
import Commons
import SANPLLibrary
import Helpers
import Commons

struct BSanDataProviderMockBuilder {
    
    static var bsanDataProvider: SANPLLibrary.BSANDataProvider {
        let versionInfo = VersionInfoDTO(bundleIdentifier: "BSANPLLibrary",
                                         versionName: "0.1")
        let dataRepository = DataRepositoryBuilder(appInfo: versionInfo).build()
        
        return SANPLLibrary.BSANDataProvider(dataRepository: dataRepository)
    }
}

public struct DataRepositoryBuilder {
    let appInfo: VersionInfoDTO
    
    public init(appInfo: VersionInfoDTO) {
        self.appInfo = appInfo
    }
    
    public func build() -> DataRepository {
        let memoryDataSource = MemoryDataSource()
        let sharedKeyChainService = SharedKeyChainService(accessGroupName: "TEST")
        let bbddDataSource: BBDDDataSource = BBDDDataSource(serializer: JSONSerializer(), keychainService: sharedKeyChainService, appInfo: appInfo)
        let dataSources: [DataSource] = [bbddDataSource, memoryDataSource]
        return DataRepositoryImpl(dataSourceProvider: DataSourceProviderImpl(defaultDataSource: memoryDataSource, dataSources: dataSources), appInfo: appInfo)
    }
}
