//
//  PLScaAuthCoordinatorProtocol.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/7/21.
//

import Models

protocol PLScaAuthCoordinatorProtocol: PLLoginCoordinatorProtocol {
    var deviceDataCoordinator: PLDeviceDataCoordinator { get }
    func goToGlobalPositionScene(_ option: GlobalPositionOptionEntity)
    func goToUnrememberedLogindScene()
    func goToDeviceTrustDeviceData()
}

extension PLScaAuthCoordinatorProtocol {
    func goToGlobalPositionScene(_ option: GlobalPositionOptionEntity) {
        self.goToPrivate(option)
    }

    func goToUnrememberedLogindScene() {
        self.backToLogin()
    }

    func goToDeviceTrustDeviceData() {
        self.deviceDataCoordinator.start()
    }
}
