import XCTest
@testable import SANPLLibrary
import DataRepository
import Repository
import SANLegacyLibrary

class Tests: XCTestCase {
    
    private var expectedAnswer: Int?
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
                                   defaultDemoUser: "12345678Z", demoModeAvailable: true,
                                   expectedAnswer: self.expectedAnswer)
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
    
    func setUpDemoUser(_ answer: Int? = 0) {
        self.expectedAnswer = answer
        guard self.demoInterpreter.isDemoModeAvailable,
              self.demoInterpreter.isDemoUser(userName: "12345678Z") else { return }
        self.bsanDataProvider.setDemoMode(true, "12345678Z")
    }
}
