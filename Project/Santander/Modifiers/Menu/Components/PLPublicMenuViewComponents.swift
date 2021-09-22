//
//  PLPublicMenuViewComponents.swift
//  Santander
//
//  Created by crodrigueza on 21/9/21.
//

import Foundation
import Menu
import Commons
import UI

final class PLPublicMenuViewComponents: PublicMenuViewComponents {
    
    public override init(resolver: DependenciesResolver) {
        super.init(resolver: resolver)
    }
    
    func setExampleView() -> UIView {
        let buttonViewModel = ButtonViewModel(titleKey: "Example Button", iconKey: "icnMapPointSan")
        let type = PublicMenuButtonType(viewModel: buttonViewModel, accessibilityIdentifier: "exampleButton")
        let view = self.makeSmallButtonView(type)
        view.action = self.didSelectExampleButton
        return view
    }
}

extension PLPublicMenuViewComponents {
    func didSelectExampleButton() {
        Toast.show(localized("generic_alert_notAvailableOperation"))
    }
}
