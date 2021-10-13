//
//  PLNotificationGetTokenAndRegisterUseCase.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 29/9/21.
//

import Foundation
import Commons
import PLCommons
import DomainCommon
import PLNotifications
import os

public final class PLGetNotificationTokenAndRegisterUseCase {
    var dependenciesEngine: DependenciesResolver & DependenciesInjector

    private enum Constants {
        static let firebaseServiceName = "Firebase"
    }

    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine

        self.dependenciesEngine.register(for: PLNotificationRegisterUseCase.self) { resolver in
            return PLNotificationRegisterUseCase(dependenciesResolver: resolver)
        }
    }

    private var notificationsHandler: NotificationsHandlerProtocol {
        return self.dependenciesEngine.resolve(for: NotificationsHandlerProtocol.self)
    }

    private var notificationRegisterUseCase: PLNotificationRegisterUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationRegisterUseCase.self)
    }

    public func executeUseCase(completion: @escaping () -> Void) {

        self.notificationsHandler.tokenForServiceIdentifier(Constants.firebaseServiceName) { token, error in
            guard let token = token else { return }
            let input = PLNotificationRegisterUseCaseInput(notificationToken: token)
            Scenario(useCase: self.notificationRegisterUseCase, input: input)
                .execute(on: self.dependenciesEngine.resolve())
                .onSuccess { _ in
                    os_log("[LOGIN][Notification token registering] Registered Firebase token %@", log: .default, type: .info, token)
                }.onError { _ in
                    os_log("❌ [LOGIN][Notification token registering] Error registering Firebase token", log: .default, type: .error)
                }.finally {
                    completion()
                }
        }
    }
}
