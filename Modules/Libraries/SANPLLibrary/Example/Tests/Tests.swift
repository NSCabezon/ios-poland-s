import XCTest
@testable import SANPLLibrary
import DataRepository
import Repository
import SANLegacyLibrary
import Commons

class Tests: XCTestCase {
    
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var expectedAnswer: Int?
    private var trustedHeadersProvider: PLTrustedHeadersGenerable!
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
        return DemoUserInterpreter(
            bsanDataProvider: self.bsanDataProvider,
            defaultDemoUser: "12345678Z",
            demoModeAvailable: true,
            expectedAnswer: self.expectedAnswer
        )
    }
   
    public var networkProvider: NetworkProvider {
        return PLNetworkProvider(
            dataProvider: self.bsanDataProvider,
            demoInterpreter: self.demoInterpreter,
            isTrustInvalidCertificateEnabled: false,
            trustedHeadersProvider: trustedHeadersProvider
        )
    }
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        self.bsanDataProvider.storeEnviroment(BSANEnvironments.environmentPre)
        setUpDependencies()
        trustedHeadersProvider = dependencies.resolve(for: PLTrustedHeadersGenerable.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
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

private extension Tests {
    func setUpDependencies() {
        
        dependencies.register(for: PLTrustedHeadersGenerable.self) { _ in
            PLTrustedHeadersProviderMock()
        }
        let demoInterpreter = DemoUserInterpreter(
            bsanDataProvider: bsanDataProvider,
            defaultDemoUser: "12345678Z",
            demoModeAvailable: true
        )
        dependencies.register(for: PLManagersProviderProtocol.self) { _ in
            PLManagersProvider(
                bsanDataProvider: self.bsanDataProvider,
                hostProvider: PLHostProviderMock(),
                networkProvider: self.networkProvider,
                demoInterpreter: demoInterpreter
            )
        }
    }
}
