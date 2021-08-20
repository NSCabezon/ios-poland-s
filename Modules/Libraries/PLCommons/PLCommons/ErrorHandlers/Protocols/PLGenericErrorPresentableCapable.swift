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
    func presentError(_ textKey: String, completion: @escaping (() -> Void))
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
        let text:LocalizedStylableText = localized(error.getErrorDesc())
        let config = LocalizedStylableTextConfiguration(alignment: .center)
        
        associatedLoadingView.dismissLoading(completion: { [weak self] in
            self?.associatedDialogView.showDialog(items: [.styledConfiguredText(text,configuration: config)],
                                                  action: Dialog.Action(title: localized("generic_button_understand"),
                                                                        style: .red,
                                                                        action: completion),
                                                  closeButton: Dialog.CloseButton.none)
        })
    }
    
    public func presentError(_ textKey: String, completion: @escaping (() -> Void) = {}) {
        let textStylableText:LocalizedStylableText = localized(textKey)
        let config = LocalizedStylableTextConfiguration(alignment: .center)
        
        associatedLoadingView.dismissLoading(completion: { [weak self] in
            self?.associatedDialogView.showDialog(items: [.styledConfiguredText(textStylableText,configuration: config)],
                                                  action: Dialog.Action(title: localized("generic_button_understand"),
                                                                        style: .red,
                                                                        action: completion),
                                                  closeButton: Dialog.CloseButton.none)
        })
    }
}

