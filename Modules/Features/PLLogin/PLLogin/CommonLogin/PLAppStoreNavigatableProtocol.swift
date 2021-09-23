//
//  PLAppStoreNavigatableProtocol.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 31/8/21.
//

import Foundation
import StoreKit
import Helpers
import PLCommons

protocol PLAppStoreNavigatableProtocol: SKStoreProductViewControllerDelegate {
    func openAppStore()
}

class PLAppStoreNavigator: NSObject, PLAppStoreNavigatableProtocol {
    
    enum Constants {
        static let storeId = PLConstants.appStoreId
    }
    
    func openAppStore() {
        guard let topViewController = UINavigationController.topVisibleViewController else { return }
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: Constants.storeId)]
        storeViewController.loadProduct(withParameters: parameters, completionBlock: nil)
        topViewController.present(storeViewController, animated: true, completion: nil)
    }
    
    @nonobjc func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
