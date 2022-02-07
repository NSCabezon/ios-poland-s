//
//  PLNotificationTokenRegisterProcessGroup.swift
//  PLLogin
//
//  Created by Marcos Álvarez Mesa on 29/9/21.
//

import Foundation
import CoreFoundationLib
import PLCommons
import PLNotifications
import os

final class PLNotificationTokenRegisterProcessGroup: ProcessGroup<Void, Void, PLNotificationTokenRegisterProcessGroupError> {

    private enum Constants {
        static let firebaseServiceName = "Firebase"
    }

    private var notificationsHandler: NotificationsHandlerProtocol {
        return self.dependenciesEngine.resolve(for: NotificationsHandlerProtocol.self)
    }

    private var notificationRegisterUseCase: PLNotificationRegisterUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationRegisterUseCase.self)
    }

    override func registerDependencies() {
        self.dependenciesEngine.register(for: PLNotificationRegisterUseCase.self) { resolver in
            return PLNotificationRegisterUseCase(dependenciesResolver: resolver)
        }
    }

    override func execute(completion: @escaping (Result<Void, PLNotificationTokenRegisterProcessGroupError>) -> Void) {
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
                    completion(.success(()))
                }
        }
    }
}

struct PLNotificationTokenRegisterProcessGroupError: Error {}
