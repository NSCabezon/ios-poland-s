
import CoreFoundationLib
import CoreFoundationLib

struct PLTransferSettingsRepository: BaseRepository {
    typealias T = PLTransferSettingsDTO
    
    let datasource: FullDataSource<PLTransferSettingsDTO, CodableParser<PLTransferSettingsDTO>>
    
    init(netClient: NetClient, assetsClient: AssetsClient, fileClient: FileClient) {
        let parameters = BaseDataSourceParameters(relativeURL: "/apps/SAN/", fileName: "transfersSettings.json")
        let parser = CodableParser<PLTransferSettingsDTO>()
        datasource = FullDataSource<PLTransferSettingsDTO, CodableParser<PLTransferSettingsDTO>>(netClient: netClient,
                                                                                                 assetsClient: assetsClient,
                                                                                                 fileClient: fileClient,
                                                                                                 parser: parser,
                                                                                                 parameters: parameters)
    }
}
