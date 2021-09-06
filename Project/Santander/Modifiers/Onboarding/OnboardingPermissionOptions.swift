//
//  OnboardingPermissionOptions.swift
//  Santander
//

import RetailLegacy

class OnboardingPermissionOptions: OnboardingPermissionOptionsProtocol {
    func getOptions() -> [FirstBoardingPermissionType] {
        [.notifications, .location]
    }
}
