import CoreFoundationLib

extension SessionConfiguration {
    static func stub(
        timeToExpireSession: TimeInterval = 1,
        timeToRefreshToken: TimeInterval? = 1,
        sessionStartedActions: [SessionStartedAction] = [],
        sessionFinishedActions: [SessionFinishedAction] = []
    ) -> Self {
        SessionConfiguration(
            timeToExpireSession: timeToExpireSession,
            timeToRefreshToken: timeToRefreshToken,
            sessionStartedActions: sessionStartedActions,
            sessionFinishedActions: sessionFinishedActions
        )
    }
}
