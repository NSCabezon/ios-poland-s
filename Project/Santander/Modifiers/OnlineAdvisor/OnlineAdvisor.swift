//
//  OnlineAdvisorVC.swift
//  Santander
//
//  Created by 185998 on 16/03/2022.
//

import Foundation
import Vcc
import CoreFoundationLib
import PLHelpCenter
import UIKit
import UI
import OpenCombine
import UIOneComponents

public class OnlineAdvisorManager: NSObject, PLOnlineAdvisorManagerProtocol {
    var viewController: VccViewController?
    var floatingButtonWindow: FloatingButtonWindow?
    var initialParams: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    public func open(initialParams: String) {
        self.initialParams = initialParams
        viewController = VccViewController()
        guard let viewController = viewController else { return }
        let configuration = VccConfiguration()
        configuration.initialParams = initialParams
        viewController.configuration = configuration
        viewController.vccDelegate = self
        viewController.startInteraction()
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(viewController,
                                    animated: true,
                                    completion: nil)
    }

    public func pauseScreenSharing() {
        viewController?.pauseScreenSharingForSensitiveData()
    }

    public func resumeScreenSharing() {
        viewController?.resumeScreenSharingAfterSensitiveData()
    }
    
    func showNewMessageToastView() {
        let toast = OneToastView()
        let model = OneToastViewModel(leftIconKey: "oneIcnAlert",
                                     titleKey: nil,
                                     subtitleKey: localized("pl_onlineAdvisor_toast_backToConversation"),
                                     linkKey: localized("pl_onlineAdvisor_button_backToConversation"),
                                     type: .large,
                                     position: .top,
                                     duration: .custom(5))
    
        toast.setViewModel(model)
        toast.publisher
            .case(ReactiveOneToastViewState.didPressOptionalLink)
            .sink { [weak self ] _ in
                guard let initialParams = self?.initialParams else { return }
                self?.open(initialParams: initialParams)
                }.store(in: &subscriptions)
        toast.present()
    }
}

extension OnlineAdvisorManager: VccViewControllerDelegate {
    
    public func vccViewControllerDidFinish(_ needToDismissVcc: Bool, reason: VccViewControllerReason) {
        if needToDismissVcc {
            viewController?.dismiss(animated: true, completion: {})
        }
    }
    
    public func vccViewControllerWillMinimize() {
        viewController?.dismiss(animated: true,
                                completion: nil)
    }
    
    public func vccViewControllerDidMinimize() {
    }
    
    public func vccViewControllerNewMessageArrived() {
        showNewMessageToastView()
    }
    
    public func vccViewControllerDidStopScreenSharing() {
        floatingButtonWindow?.dismiss()
        floatingButtonWindow = nil
        
        guard let viewController = viewController else { return }
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(viewController,
                                    animated: true,
                                    completion: nil)
        
    }
    
    public func stopScreenSharingConfirmAlert() {
        let confirmationAlert = UIAlertController(
            title: nil,
            message: localized("pl_screensharing_message_confirmTheEndQuestion"),
            preferredStyle: .alert
        )
        
        confirmationAlert.addAction(
            UIAlertAction(
                title: localized("generic_link_yes"),
                style: .destructive,
                handler: { [weak self] _ in
                    self?.viewController?.stopScreenSharing()
                }
            )
        )
        confirmationAlert.addAction(
            UIAlertAction(
                title: localized("generic_link_no"),
                style: .cancel
            )
        )
        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(confirmationAlert,
                                    animated: true,
                                    completion: nil)
    }
    
    public func vccViewControllerDidStartScreenSharing() {
        let floatingButtonWindow = FloatingButtonWindow()
        let floatingButtonController = FloatingButtonController(
            window: floatingButtonWindow,
            onStopBlock: { [weak self] in
                self?.stopScreenSharingConfirmAlert()
            }
        )
        floatingButtonController.setupKeyboard()
        floatingButtonWindow.present(viewController: floatingButtonController)
        self.floatingButtonWindow = floatingButtonWindow
    }

}
