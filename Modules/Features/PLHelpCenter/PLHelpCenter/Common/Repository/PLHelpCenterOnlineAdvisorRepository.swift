//
//  PLHelpCenterOnlineAdvisorRepository.swift
//  PLHelpCenter
//
//  Created by 185860 on 19/01/2022.
//

import Foundation
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

public struct PLHelpCenterOnlineAdvisorRepository: BaseRepository {
    public typealias T = OnlineAdvisorDTO
    
    public let datasource: FullDataSource<OnlineAdvisorDTO, CodableParser<OnlineAdvisorDTO>>
    
    public init(netClient: NetClient, assetsClient: AssetsClient, fileClient: FileClient) {
        let parameters = BaseDataSourceParameters(relativeURL: "apps/SAN/online-advisor/", fileName: "online_advisor.json")
        let parser = CodableParser<OnlineAdvisorDTO>()
        datasource = FullDataSource<OnlineAdvisorDTO, CodableParser<OnlineAdvisorDTO>>(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient, parser: parser, parameters: parameters)
    }
}
