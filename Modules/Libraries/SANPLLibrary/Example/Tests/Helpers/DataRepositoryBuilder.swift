//
//  DataRepositoryBuilder.swift
//  SANPLLibrary_Tests
//
//  Created by Marcos Álvarez Mesa on 18/5/21.
//

import CoreFoundationLib
import Repository

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
