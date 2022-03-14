//
//  PLNotificationsProcessGroup.swift
//  PLNotificationsUseCaseManager
//
//  Created by 188418 on 13/01/2022.
//

import CoreFoundationLib
import PLNotifications
import os
import SANPLLibrary

public protocol PLNotificationsUseCaseManagerProtocol {
    func getList(completion: @escaping (PLNotificationListEntity?) -> Void)
    func getPushById(pushId: Int, completion: @escaping (PLNotificationEntity?) -> Void)
    func getPushBeforeLogin(pushId: Int, loginId: Int, completion: @escaping (PLNotificationEntity?) -> Void)
    func getUnreadedPushesCount(enabledPushCategories: [EnabledPushCategorie], completion: @escaping (PLUnreadedPushCountEntity?) -> Void)
    func getEnabledPushCategories(completion: ((PLEnabledPushCategoriesListEntity?) -> Void)?)
    func postPushStatus(pushStatus: PLPushStatusUseCaseInput, completion: @escaping (PLPushStatusResponseEntity?) -> Void)
    func postPushStatusBeforeLogin(pushStatus: PLPushStatusUseCaseInput, completion: @escaping (PLPushStatusResponseEntity?) -> Void)
    func postPushListPageSize(postPushListPageSizeDTO: PLPostPushListPageSizeUseCaseInput, completion: @escaping (PLNotificationListEntity?) -> Void)
    func postPushSetAllStatus(completion: @escaping () -> Void)
}

public class PLNotificationsUseCaseManager {
    private let dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    private var notificationGetPushListUseCase: PLNotificationGetPushListUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationGetPushListUseCase.self)
    }
    
    private var notificationGetPushDetailsUseCase: PLNotificationGetPushDetailsUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationGetPushDetailsUseCase.self)
    }
    
    private var notificationGetPushDetailsBeforeLoginUseCase: PLNotificationGetPushDetailsBeforeLoginUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationGetPushDetailsBeforeLoginUseCase.self)
    }
    
    private var notificationGetUnreadedPushCountUseCase: PLNotificationGetUnreadedPushCountUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationGetUnreadedPushCountUseCase.self)
    }
    
    private var notificationGetEnabledPushCategoriesByDeviceUseCase: PLNotificationGetEnabledPushCategoriesByDeviceUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationGetEnabledPushCategoriesByDeviceUseCase.self)
    }
    
    private var notificationPostPushStatusUseCase: PLNotificationPostPushStatusUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationPostPushStatusUseCase.self)
    }
    
    private var notificationPostPushStatusBeforeLoginUseCase: PLNotificationPostPushStatusBeforeLoginUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationPostPushStatusBeforeLoginUseCase.self)
    }
    
    private var notificationPostSetAllPushStatusUseCase: PLNotificationPostSetAllPushStatusUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationPostSetAllPushStatusUseCase.self)
    }
    
    private var notificationPostPushListPageSizeUseCase: PLNotificationPostPushListPageSizeUseCase {
        return self.dependenciesEngine.resolve(for: PLNotificationPostPushListPageSizeUseCase.self)
    }
    
    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
    }
}

extension PLNotificationsUseCaseManager: PLNotificationsUseCaseManagerProtocol {
    public func postPushListPageSize(postPushListPageSizeDTO: PLPostPushListPageSizeUseCaseInput, completion: @escaping (PLNotificationListEntity?) -> Void) {
        Scenario(useCase: self.notificationPostPushListPageSizeUseCase, input: postPushListPageSizeDTO)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { response in
                completion(response.entity)
            }.onError { error in
                completion(nil)
            }
        
    }
    
    public func getList(completion: @escaping (PLNotificationListEntity?) -> Void) {
        Scenario(useCase: self.notificationGetPushListUseCase)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { response in
                completion(response.entity)
            }.onError { error in
                completion(nil)
            }
    }
    
    public func getPushById(pushId: Int, completion: @escaping (PLNotificationEntity?) -> Void) {
        let input = GetPushDetailsUseCaseInput(pushId: pushId)
        Scenario(useCase: self.notificationGetPushDetailsUseCase, input: input)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { response in
                completion(response.entity)
            }.onError { error in
                completion(nil)
            }
    }
    
    
    public func getPushBeforeLogin(pushId: Int, loginId: Int, completion: @escaping (PLNotificationEntity?) -> Void) {
        let input = GetPushDetailsBeforeLoginUseCaseInput(pushId: pushId, loginId: loginId)
        Scenario(useCase: self.notificationGetPushDetailsBeforeLoginUseCase, input: input)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { response in
                completion(response.entity)
            }.onError { error in
                completion(nil)
            }
    }
    
    
    public func getUnreadedPushesCount(enabledPushCategories: [EnabledPushCategorie], completion: @escaping (PLUnreadedPushCountEntity?) -> Void) {
        let input = GetUnreadedPushCountUseCaseInput(enabledPushCategories: enabledPushCategories)
        Scenario(useCase: self.notificationGetUnreadedPushCountUseCase, input: input)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { response in
                completion(response.entity)
            }.onError { error in
                completion(nil)
            }
    }
    
    public func getEnabledPushCategories(completion: ((PLEnabledPushCategoriesListEntity?) -> Void)?) {
        Scenario(useCase: self.notificationGetEnabledPushCategoriesByDeviceUseCase)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { response in
                completion?(response.entity)
            }.onError { error in
                completion?(nil)
            }
    }
    
    public func postPushSetAllStatus(completion: @escaping () -> Void) {
        Scenario(useCase: self.notificationPostSetAllPushStatusUseCase)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { _ in
                completion()
            }
    }
    
    public func postPushStatus(pushStatus: PLPushStatusUseCaseInput, completion: @escaping (PLPushStatusResponseEntity?) -> Void) {
        let input = NotificationPostPushStatusInput(pushStatus: pushStatus)
        Scenario(useCase: self.notificationPostPushStatusUseCase, input: input)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { response in
                completion(response.entity)
            }.onError { error in
                completion(nil)
            }
    }
    
    public func postPushStatusBeforeLogin(pushStatus: PLPushStatusUseCaseInput, completion: @escaping (PLPushStatusResponseEntity?) -> Void) {
        let input = NotificationPostPushStatusInput(pushStatus: pushStatus)
        Scenario(useCase: self.notificationPostPushStatusBeforeLoginUseCase, input: input)
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { response in
                completion(response.entity)
            }.onError { error in
                completion(nil)
            }
    }
    
}
