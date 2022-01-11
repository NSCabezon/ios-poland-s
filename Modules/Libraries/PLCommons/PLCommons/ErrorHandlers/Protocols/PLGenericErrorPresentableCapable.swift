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
    func presentErrorWithoutTitle(_ error: PLGenericError, completion: @escaping (() -> Void))
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
        self.presentError(localizedTitleKey: "pl_onboarding_alert_genFailedTitle",
                          localizedDescriptionKey: error.getErrorDesc(),
                          completion: completion)
    }

    public func presentErrorWithoutTitle(_ error: PLGenericError, completion: @escaping (() -> Void) = {}) {
        self.presentError(localizedDescriptionKey: error.getErrorDesc(),
                          completion: completion)
    }
    
    public func presentError(_ textKeys: (titleKey: String, descriptionKey: String),
                             completion: @escaping (() -> Void) = {}) {
        self.presentError(localizedTitleKey: textKeys.titleKey,
                          localizedDescriptionKey: textKeys.descriptionKey,
                          completion: completion)
    }
}

private extension UIViewController {

    enum Constants {
        static let absoluteMargin: (left: CGFloat, right: CGFloat) = (left: 19.0, right: 9.0)
        static let image = LisboaDialogImageViewItem(image: Assets.image(named: "icnDanger"), size: (70, 70))
        static let titleFont = UIFont.santander(family: .text, type: .bold, size: 28)
        static let descriptionFont = UIFont.santander(family: .text, type: .light, size: 16)
    }

    func presentError(localizedTitleKey: String? = nil,
                      localizedDescriptionKey: String,
                      completion: @escaping (() -> Void) = {}) {
        var components = [LisboaDialogItem]()
        if let localizedTitleKey = localizedTitleKey {
            components.append(.image(Constants.image))
            components.append(.styledText(
                LisboaDialogTextItem(
                    text: localized(localizedTitleKey),
                    font: Constants.titleFont,
                    color: .lisboaGray,
                    alignament: .center,
                    margins: Constants.absoluteMargin)))
        }
        components.append(.margin(12.0))
        components.append(.styledText(
            LisboaDialogTextItem(
                text:  localized(localizedDescriptionKey),
                font: Constants.descriptionFont,
                color: .lisboaGray,
                alignament: .center,
                margins: Constants.absoluteMargin)))
        components.append(.margin(24.0))
        components.append(.verticalAction(VerticalLisboaDialogAction(title: localized("generic_button_understand"),
                                                                     type: LisboaDialogActionType.red,
                                                                     margins: (left: 16, right: 16), action: completion)))
        components.append(.margin(16.0))
        let builder = LisboaDialog(items: components, closeButtonAvailable: false)
        self.associatedLoadingView.dismissLoading(completion: { [weak self] in
            guard let self = self else { return }
            builder.showIn(self.associatedDialogView)
        })
    }
}

