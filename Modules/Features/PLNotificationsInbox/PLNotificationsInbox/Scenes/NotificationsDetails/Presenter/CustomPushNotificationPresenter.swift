//
//  CustomPushNotificationPresenter.swift
//  Santander
//
//  Created by 188418 on 28/12/2021.
//

import UIKit
import PLNotifications
import CoreFoundationLib
import PLLogin
import UI
import SANPLLibrary

protocol CustomPushNotificationPresenterProtocol: MenuTextWrapperProtocol {
    var view: CustomPushNotificationViewProtocol? { get set }
    func setType(_ actionType: CustomPushLaunchAction)
    func viewDidLoad()
    func didSelectClose()
}

final class CustomPushNotificationPresenter {
    var actionType: CustomPushLaunchAction?
    weak var view: CustomPushNotificationViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    var content: String = ""
}

extension CustomPushNotificationPresenter: CustomPushNotificationPresenterProtocol {
    func setType(_ actionType: CustomPushLaunchAction) {
        self.actionType = actionType
    }
    
    func viewDidLoad() {
        if let content = self.actionType?.content {
            view?.openHtml(replacingCharactersInHtml(content))
        } else {
            getPushContent()
        }
    }
    
    func showHtml() {
        self.view?.openHtml(replacingCharactersInHtml(self.content))
    }
    
    func didSelectClose() {
        coordinator.pop()
    }
    
    func replacingCharactersInHtml(_ response: String) -> String {
        guard let encodedData = response.data(using: .utf8) else {
            return response
        }
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributedString = try NSAttributedString(data: encodedData,
                                                          options: attributedOptions,
                                                          documentAttributes: nil)
            return attributedString.string
        } catch {
            return response
        }
    }
    
    private func getPushFor(userId: Int) {
        let notificationUseCase = dependenciesResolver.resolve(for: PLNotificationsUseCaseManagerProtocol.self)
        guard let pushId =  self.actionType?.messageId else { return }
        notificationUseCase.getPushBeforeLogin(pushId: pushId, loginId: userId) { [weak self] response in
            guard let response = response, let content = response.content else { return }
            self?.content = content
            self?.showHtml()
        }
    }
    
    private func getPushContent() {
        let loginUseCase: PLBeforeLoginUseCase = self.dependenciesResolver.resolve(for: PLBeforeLoginUseCase.self)
        Scenario(useCase: loginUseCase)
            .execute(on: self.dependenciesResolver.resolve())
            .onSuccess { response in
                self.getPushFor(userId: response.userId)
                self.markAsRead(userId: response.userId)
            }
            .onError { error in
                Toast.show(error.localizedDescription)
            }
    }
    
    private func markAsRead(userId: Int){
        guard let notificationId = actionType?.messageId else { return }
        let notificationUseCase = dependenciesResolver.resolve(for: PLNotificationsUseCaseManagerProtocol.self)
        let input = PLPushStatusUseCaseInput(pushList: [PLPushStatus(id: notificationId, status: NotificationStatus.read.rawValue)],
                                             loginId: userId)
        notificationUseCase.postPushStatusBeforeLogin(pushStatus: input, completion: { _ in })
    }
}

private extension CustomPushNotificationPresenter {
    var coordinator: CustomPushNotificationCoordinatorProtocol {
        dependenciesResolver.resolve(for: CustomPushNotificationCoordinatorProtocol.self)
    }
}
