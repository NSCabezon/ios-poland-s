//
//  OnboardingPermissionOptions.swift
//  Santander
//

import Commons

class OnboardingPermissionOptions: OnboardingPermissionOptionsProtocol {
    func getOptions() -> [OnboardingPermissionType] {
        [.notifications, .location]
    }
}
