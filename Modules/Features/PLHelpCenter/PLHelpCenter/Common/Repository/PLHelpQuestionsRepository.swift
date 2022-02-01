//
//  PLHelpHelpQuestionsRepository.swift
//  PLHelpCenter
//
//  Created by 185860 on 19/01/2022.
//

import Foundation
import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary
import SANLegacyLibrary

public struct PLHelpQuestionsRepository: BaseRepository {
    public typealias T = HelpQuestionsDTO
    
    public let datasource: FullDataSource<HelpQuestionsDTO, CodableParser<HelpQuestionsDTO>>
    
    public init(netClient: NetClient, assetsClient: AssetsClient, fileClient: FileClient) {
        let parameters = BaseDataSourceParameters(relativeURL: "apps/SAN/online-advisor/", fileName: "help_questions.json")
        let parser = CodableParser<HelpQuestionsDTO>()
        datasource = FullDataSource<HelpQuestionsDTO, CodableParser<HelpQuestionsDTO>>(netClient: netClient, assetsClient: assetsClient, fileClient: fileClient, parser: parser, parameters: parameters)
    }
}
