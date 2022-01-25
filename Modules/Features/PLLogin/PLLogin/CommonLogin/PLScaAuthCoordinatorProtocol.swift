//
//  PLScaAuthCoordinatorProtocol.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/7/21.
//

import CoreFoundationLib
import CoreDomain

protocol PLScaAuthCoordinatorProtocol: PLLoginCoordinatorProtocol {
    var deviceTrustDeviceDataCoordinator: PLDeviceDataCoordinator { get set }
    var navigationController: UINavigationController? { get set }
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
        self.deviceTrustDeviceDataCoordinator.start()
    }
}
