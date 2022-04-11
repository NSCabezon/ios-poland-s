//
//  OnboardingPermissionOptions.swift
//  Santander
//

import CoreFoundationLib

class OnboardingPermissionOptions: OnboardingPermissionOptionsProtocol {
    func getOptions() -> [OnboardingPermissionType] {
        [.notifications, .location]
    }
}
