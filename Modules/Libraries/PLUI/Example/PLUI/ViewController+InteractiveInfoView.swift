//
//  ViewController+InteractiveInfoView.swift
//  PLUI_Example
//
//  Created by Marcos Álvarez Mesa on 7/7/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import PLUI
import UI

extension ViewController {

    func interactiveInfoView() -> PLUIInteractiveInfoView {
        let image = PLAssets.image(named: "fingerprint")
        let infoView = PLUIInteractiveInfoView(image: image!,
                                               title: "This is the title",
                                               text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore")
        infoView.delegate = self
        return infoView
    }
}

extension ViewController: PLUIInteractiveInfoViewDelegate {
    func interactiveInfoView(_: PLUIInteractiveInfoView, didChangeSwitch value: Bool) {

        print("Switcher activated: \(value)")
    }
}
