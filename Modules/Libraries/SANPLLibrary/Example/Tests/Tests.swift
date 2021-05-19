import XCTest
@testable import SANPLLibrary
import DataRepository
import Commons
import Repository
import SANLegacyLibrary

class Tests: XCTestCase {

    private lazy var dataRepository: DataRepository = {

        let versionInfo = VersionInfoDTO(bundleIdentifier: "BSANPLLibrary",
                                         versionName: "0.1")
        let dataRepositoryBuilder = DataRepositoryBuilder(appInfo: versionInfo)
        return dataRepositoryBuilder.build()
    }()

    public var bsanDataProvider: SANPLLibrary.BSANDataProvider {
        return SANPLLibrary.BSANDataProvider(dataRepository: self.dataRepository)
    }

    public var demoInterpreter: DemoUserInterpreter {
        return DemoUserInterpreter(bsanDataProvider: self.bsanDataProvider,
                                   defaultDemoUser: "123456789Z")
    }

    public var networkProvider: NetworkProvider {
        return PLNetworkProvider(dataProvider: self.bsanDataProvider,
                                 demoInterpreter: self.demoInterpreter,
                                 isTrustInvalidCertificateEnabled: false)
    }
    
    override func setUp() {
        super.setUp()

        self.bsanDataProvider.storeEnviroment(BSANEnvironments.environmentPre)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        self.measure() {
        }
    }
}
