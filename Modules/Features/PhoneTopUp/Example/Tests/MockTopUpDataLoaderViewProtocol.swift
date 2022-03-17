//
//  MockTopUpDataLoaderViewProtocol.swift
//  PhoneTopUp_Tests
//
//  Created by 188216 on 11/03/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UI
@testable import PhoneTopUp

final class MockTopUpDataLoaderView: TopUpDataLoaderViewProtocol {
    var associatedLoadingView = UIViewController()
    var showLoaderCallCount = 0
    var hideLoaderCallCount = 0
    var showErrorMessageCallCount = 0
    
    func showLoader() {
        showLoaderCallCount += 1
    }
    
    func hideLoader(completion: (() -> Void)?) {
        hideLoaderCallCount += 1
        completion?()
    }
    
    func showServiceInaccessibleMessage(onConfirm: (() -> Void)?) {
        showErrorMessageCallCount += 1
        onConfirm?()
    }
    
    func showErrorMessage(_ message: String, onConfirm: (() -> Void)?) {
        showErrorMessageCallCount += 1
        onConfirm?()
    }
    
    func showErrorMessage(_ message: String, image: String, onConfirm: (() -> Void)?) {
        showErrorMessageCallCount += 1
        onConfirm?()
    }
    
    func showErrorMessage(title: String, message: String, image: String, onConfirm: (() -> Void)?) {
        showErrorMessageCallCount += 1
        onConfirm?()
    }
    
    func showErrorMessage(title: String, message: String, actionButtonTitle: String, closeButton: Dialog.CloseButton, onConfirm: (() -> Void)?) {
        showErrorMessageCallCount += 1
        onConfirm?()
    }
}
