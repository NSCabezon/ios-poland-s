//
//  PLLoadingLoginViewCapable.swift
//  PLLogin

import Foundation
import Commons
import UI

protocol PLLoadingLoginViewCapable: LoadingViewPresentationCapable {}

extension PLLoadingLoginViewCapable {
    func showLoadingText(title: LocalizedStylableText, subtitle: LocalizedStylableText) {
        self.setLoadingText(LoadingText(title: title, subtitle: subtitle))
    }
    
    func showLoadingPlaceHolders() {
        let loadingText = LoadingText(
            title: localized("login_popup_loadingPg"),
            subtitle: localized("loading_label_moment")
        )
        let placeholders = [
            Placeholder("pgPlaceholderFakeTop", 0),
            Placeholder("pgPlaceholderFakeOfert", 14),
            Placeholder("pgPlaceholderFakeProduct", 14),
            Placeholder("pgPlaceholderFakeProduct", 14)
        ]
        self.setLoadingText(loadingText)
        let topInset = 44 + Screen.statusBarHeight
        self.setPlaceholder(placeholders, topInset: topInset, background: .paleGrey)
    }
    
    func showLoadingWithInfo(completion: (() -> Void)?) {
        let loadingText = LoadingText(
            title: localized("login_popup_identifiedUser"),
            subtitle: localized("loading_label_moment")
        )
        let type = LoadingViewType.onScreen(controller: self.associatedLoadingView, completion: completion)
        let info = LoadingInfo(type: type, loadingText: loadingText, placeholders: nil, topInset: nil)
        self.showLoadingWithLoading(info: info)
    }
}

