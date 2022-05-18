import CoreTestData

public final class PLServiceInjector: CustomServiceInjector {
    public init() {}
    public func inject(injector: MockDataInjector) {
        injector.register(
            for: \.gpData.getGlobalPositionMock,
            filename: "obtenerPosGlobal"
        )
        injector.register(
            for: \.pullOffersConfig.getPullOffersConfig,
            filename: "pull_offers_configV4_without_cushion"
        )
        injector.register(
            for: \.appConfigLocalData.getAppConfigLocalData,
            filename: "app_config_v2"
        )
    }
}

