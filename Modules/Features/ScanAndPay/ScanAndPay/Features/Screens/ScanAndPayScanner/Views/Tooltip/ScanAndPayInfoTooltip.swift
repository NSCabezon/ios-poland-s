//
//  InfoToolTip.swift
//  ScanAndPay
//
//  Created by 188216 on 22/03/2022.
//

import Foundation
import CoreFoundationLib
import UI
import PLUI

final class ScanAndPayInfoToolTip {
    private let description: LocalizedStylableText = localized("pl_scanAndPay_tooltip")
    private let descriptionView: LabelTooltipView
    
    init() {
        let textConfiguration = LabelTooltipViewConfiguration(
            text: description, left: 18, right: 18,
            font: .santander(family: .micro, type: .regular, size: 14), textColor: .lisboaGray)
        self.descriptionView = LabelTooltipView(configuration: textConfiguration)
    }
    
    func show(in viewController: UIViewController, from sender: UIView?, completion: @escaping () -> Void) {
        let stickyItems: [FullScreenToolTipViewItemData] = []
        let scrolledItems: [FullScreenToolTipViewItemData] = [
            FullScreenToolTipViewItemData(view: descriptionView, bottomMargin: 26),
            FullScreenToolTipViewItemData(view: createQrCodeView(), bottomMargin: 16),
        ]
        let configuration = FullScreenToolTipViewData(topMargin: 0,
                                                      stickyItems: stickyItems,
                                                      scrolledItems: scrolledItems,
                                                      closeIdentifier: nil,
                                                      containerIdentifier: nil,
                                                      roundedCornes: 6,
                                                      showCloseButton: false,
                                                      dismissOutside: true)
        configuration.show(in: viewController, from: sender, isInitialToolTip: false, completion: completion)
    }
    
    private func createQrCodeView() -> UIView {
        let container = UIView()
        let imageView = UIImageView(image: Images.Scanner.qrCodeImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        let constraints = [
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.3),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0),
        ]
        constraints.forEach({ $0.isActive = true })
        return container
    }
}
