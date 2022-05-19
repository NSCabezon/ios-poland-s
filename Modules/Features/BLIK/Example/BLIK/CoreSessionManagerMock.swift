import CoreFoundationLib

struct CoreSessionManagerMock: CoreSessionManager {
    var configuration: SessionConfiguration
    var isSessionActive: Bool
    var lastFinishedSessionReason: SessionFinishedReason?
    
    init(
        configuration: SessionConfiguration = SessionConfiguration.stub(),
        isSessionActive: Bool = true,
        lastFinishedSessionReason: SessionFinishedReason? = .logOut
    ) {
        self.configuration = configuration
        self.isSessionActive = isSessionActive
        self.lastFinishedSessionReason = lastFinishedSessionReason
    }

    func setLastFinishedSessionReason(_ reason: SessionFinishedReason) {}
    
    func sessionStarted(completion: (() -> Void)?) {
        completion?()
    }
    
    func finishWithReason(_ reason: SessionFinishedReason) {}
}
