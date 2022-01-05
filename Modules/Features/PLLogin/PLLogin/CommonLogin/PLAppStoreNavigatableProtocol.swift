//
//  PLAppStoreNavigatableProtocol.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 31/8/21.
//

import Foundation
import StoreKit
import CoreFoundationLib
import PLCommons

protocol PLAppStoreNavigatableProtocol: SKStoreProductViewControllerDelegate {
    func openAppStore(presenterViewController: UIViewController)
}

class PLAppStoreNavigator: NSObject, PLAppStoreNavigatableProtocol {
    
    enum Constants {
        static let storeId = PLConstants.appStoreId
    }
    
    private var presenterViewController: UIViewController?
    
    func openAppStore(presenterViewController: UIViewController) {
        guard let topViewController = UINavigationController.topVisibleViewController else { return }
        self.presenterViewController = presenterViewController
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: Constants.storeId)]
        storeViewController.loadProduct(withParameters: parameters, completionBlock: nil)
        topViewController.present(storeViewController, animated: true, completion: nil)
    }
}
extension PLAppStoreNavigator: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        self.presenterViewController?.viewDidAppear(true)
        viewController.dismiss(animated: true, completion: nil)
    }
}
