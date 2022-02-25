//
//  PLAccountOtherOperativesInfoRepository.swift
//  Santander
//
//  Created by Julio Nieto Santiago on 7/10/21.
//

import CoreFoundationLib

struct PLAccountOtherOperativesInfoRepository: BaseRepository {
    typealias T = PLProductOperativesDTOList
    
    let datasource: FullDataSource<PLProductOperativesDTOList, CodableParser<PLProductOperativesDTOList>>
    
    init(netClient: NetClient, assetsClient: AssetsClient, fileClient: FileClient) {
        let parameters = BaseDataSourceParameters(relativeURL: "/apps/SAN/", fileName: "operative_web_options.json")
        let parser = CodableParser<PLProductOperativesDTOList>()
        datasource = FullDataSource<PLProductOperativesDTOList, CodableParser<PLProductOperativesDTOList>>(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient, parser: parser, parameters: parameters)
    }
}
