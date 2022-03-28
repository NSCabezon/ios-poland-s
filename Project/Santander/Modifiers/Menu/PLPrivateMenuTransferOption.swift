import CoreFoundationLib

struct PLPrivateMenuTransferOption: PrivateMenuTransferOptionProtocol {
    private var dependencies: ModuleDependencies
    
    public init(dependencies: ModuleDependencies) {
        self.dependencies = dependencies
    }

    func goToTransfersHome() {
        dependencies.oneTransferHomeCoordinator().start()
    }
}
