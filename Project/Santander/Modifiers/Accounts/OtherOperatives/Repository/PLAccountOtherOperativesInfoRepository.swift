//
//  PLAccountOtherOperativesInfoRepository.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import CoreFoundationLib
import Commons
import CoreFoundationLib

struct PLAccountOtherOperativesInfoRepository: BaseRepository {
    typealias T = PLAccountOtherOperativesDTOList
    
    let datasource: FullDataSource<PLAccountOtherOperativesDTOList, CodableParser<PLAccountOtherOperativesDTOList>>
    
    init(netClient: NetClient, assetsClient: AssetsClient, fileClient: FileClient) {
        let parameters = BaseDataSourceParameters(relativeURL: "/apps/SAN/", fileName: "operative_web_options.json")
        let parser = CodableParser<PLAccountOtherOperativesDTOList>()
        datasource = FullDataSource<PLAccountOtherOperativesDTOList, CodableParser<PLAccountOtherOperativesDTOList>>(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient, parser: parser, parameters: parameters)
    }
}
