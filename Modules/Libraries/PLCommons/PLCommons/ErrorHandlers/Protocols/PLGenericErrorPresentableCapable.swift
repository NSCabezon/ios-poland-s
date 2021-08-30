//
//  PLGenericErrorPresentableCapable.swift
//  PLCommons
//
//  Created by Mario Rosales Maillo on 27/7/21.
//

import Foundation
import Commons
import UI

public protocol PLGenericErrorPresentableCapable: LoadingViewPresentationCapable, DialogViewPresentationCapable {
    func showLoadingWith(loadingText: LoadingText, completion: (() -> Void)?)
    func presentError(_ error: PLGenericError, completion: @escaping (() -> Void))
    func presentError(_ textKeys: (titleKey: String, descriptionKey: String), completion: @escaping (() -> Void))
    func presentError(_ error: PLGenericError)
}

extension UIViewController : PLGenericErrorPresentableCapable {
    public var associatedDialogView: UIViewController {
        return self
    }
    
    public var associatedLoadingView: UIViewController {
        return self
    }
        
    public func showLoadingWith(loadingText: LoadingText, completion: (() -> Void)?) {
        let type = LoadingViewType.onScreen(controller: self.associatedLoadingView, completion: completion)
        let info = LoadingInfo(type: type, loadingText: loadingText, placeholders: nil, topInset: nil)
        self.showLoadingWithLoading(info: info)
    }
    
    public func presentError(_ error: PLGenericError) {
        presentError(error, completion: {})
    }
    
    public func presentError(_ error: PLGenericError, completion: @escaping (() -> Void) = {}) {
        self.presentError((titleKey: "pl_onboarding_alert_genFailedTitle",
                           descriptionKey: error.getErrorDesc()), completion: completion)
    }
    
    public func presentError(_ textKeys: (titleKey: String, descriptionKey: String),
                             completion: @escaping (() -> Void) = {}) {
        let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 19.0, right: 9.0)
        let components: [LisboaDialogItem] = [
            .image(LisboaDialogImageViewItem(image: Assets.image(named: "icnDanger"), size: (70, 70))),
            .styledText(
                LisboaDialogTextItem(
                    text: localized(textKeys.titleKey),
                    font: .santander(family: .text, type: .bold, size: 28),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(12.0),
            .styledText(
                LisboaDialogTextItem(
                    text:  localized(textKeys.descriptionKey),
                    font: .santander(family: .text, type: .light, size: 16),
                    color: .lisboaGray,
                    alignament: .center,
                    margins: absoluteMargin)),
            .margin(24.0),
            .verticalAction(VerticalLisboaDialogAction(title: localized("generic_button_understand"), type: LisboaDialogActionType.red, margins: (left: 16, right: 16), action: completion)),
            .margin(16.0)
        ]
        let builder = LisboaDialog(items: components, closeButtonAvailable: false)
        associatedLoadingView.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            builder.showIn(self.associatedDialogView)
        })
    }
}

