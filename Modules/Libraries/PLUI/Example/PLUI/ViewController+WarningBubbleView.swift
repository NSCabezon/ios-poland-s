//
//  ViewController+WarningBubbleView.swift
//  PLUI_Example
//
//  Created by 185167 on 22/02/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import PLUI
import UI

extension ViewController {
    func warningBubbleView() -> WarningBubbleView {
        let warningView = WarningBubbleView()
        warningView.translatesAutoresizingMaskIntoConstraints = false
        warningView.configure(with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        
        return warningView
    }
}
