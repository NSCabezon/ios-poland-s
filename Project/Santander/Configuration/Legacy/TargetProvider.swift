import SANLegacyLibrary
import RetailLegacy
import Commons

final class TargetProvider: DemoInterpreterProvider {
    private let demoInterpreter: DemoInterpreter
    
    init(demoProvider: BSANDemoProviderProtocol) {
        self.demoInterpreter = DemoInterpreterImpl(demoProvider: demoProvider, defaultDemoUser: "")
    }

    func getDemoInterpreter() -> DemoInterpreter {
        return demoInterpreter
    }
}
