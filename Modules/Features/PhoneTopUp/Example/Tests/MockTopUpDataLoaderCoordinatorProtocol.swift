//
//  MockTopUpDataLoaderCoordinatorProtocol.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 10/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@testable import PhoneTopUp

final class MockTopUpDataLoaderCoordinator: TopUpDataLoaderCoordinatorProtocol {
    var navigationController: UINavigationController?
    var didCallShowForm = false
    var didCallClose = false
    var didCallStart = false
    
    func showForm(with formData: TopUpPreloadedFormData) {
        didCallShowForm = true
    }
    
    func close() {
        didCallClose = true
    }
    
    func start() {
        didCallStart = true
    }
    
    
}
