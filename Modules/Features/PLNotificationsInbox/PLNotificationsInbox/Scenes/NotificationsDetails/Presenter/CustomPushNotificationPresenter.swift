//
//  CustomPushNotificationPresenter.swift
//  Santander
//
//  Created by 188418 on 28/12/2021.
//

import UIKit
import PLNotifications
import CoreFoundationLib

protocol CustomPushNotificationPresenterProtocol: MenuTextWrapperProtocol {
    var view: CustomPushNotificationViewProtocol? { get set }
    func setType(_ actionType: CustomPushLaunchActionTypeInfo)
    func viewDidLoad()
    func didSelectClose()
}

final class CustomPushNotificationPresenter {
    var actionType: CustomPushLaunchActionTypeInfo?
    weak var view: CustomPushNotificationViewProtocol?
    let dependenciesResolver: DependenciesResolver
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension CustomPushNotificationPresenter: CustomPushNotificationPresenterProtocol {
    func setType(_ actionType: CustomPushLaunchActionTypeInfo) {
        self.actionType = actionType
    }
    
    func viewDidLoad() {
        view?.openHtml(replacingCharactersInHtml(self.actionType?.content ?? ""))
    }
    
    func didSelectClose() {
        coordinator.pop()
    }
    
    private func replacingCharactersInHtml(_ response: String) -> String {
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
}

private extension CustomPushNotificationPresenter {
    var coordinator: CustomPushNotificationCoordinatorProtocol {
        dependenciesResolver.resolve(for: CustomPushNotificationCoordinatorProtocol.self)
    }
}
