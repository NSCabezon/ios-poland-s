//
//  FloatingButtonWindow.swift
//  Santander
//
//  Created by 185998 on 18/03/2022.
//

import UIKit

final class FloatingButtonWindow: UIWindow {
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }

    override func makeKey() {}

    func present(viewController: UIViewController) {
        windowLevel = .statusBar
        isHidden = false
        rootViewController = viewController
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let views = rootViewController?.view.subviews else {
            return false
        }
        return views.contains { view in
            let viewPoint = convert(point, to: view)
            return view.point(inside: viewPoint, with: event)
        }
    }

    func dismiss() {
        isHidden = true

        if #available(iOS 13, *) {
            windowScene = nil
        }
    }
}
