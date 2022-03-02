//
//  PLTermsAndConditionsRepository.swift
//  Santander
//
//  Created by Mario Rosales Maillo on 3/2/22.
//


import CoreFoundationLib

public struct PLTermsAndConditionsRepository: BaseRepository {
    public typealias T = PLTermsAndConditionsDTO
    
    public let datasource: FullDataSource<PLTermsAndConditionsDTO, CodableParser<PLTermsAndConditionsDTO>>
    
    public init(netClient: NetClient, assetsClient: AssetsClient, fileClient: FileClient) {
        let parameters = BaseDataSourceParameters(relativeURL: "/apps/SAN/", fileName: "terms_conditions.json")
        let parser = CodableParser<PLTermsAndConditionsDTO>()
        datasource = FullDataSource<PLTermsAndConditionsDTO, CodableParser<PLTermsAndConditionsDTO>>(netClient: netClient,
                                                                                                 assetsClient: assetsClient,
                                                                                                 fileClient: fileClient,
                                                                                                 parser: parser,
                                                                                                 parameters: parameters)
    }
}

