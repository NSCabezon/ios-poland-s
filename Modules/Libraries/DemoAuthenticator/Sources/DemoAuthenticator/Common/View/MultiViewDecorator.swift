//
//  MultiViewDecorator.swift
//  Auth
//
//  Created by Łukasz Grzywacz on 15/09/2020.
//  Copyright © 2020 Santander Bank Polska. All rights reserved.
//

import UIKit

final class MultiViewDecorator {
    private let decorators: [ViewDecorating]

    init(
        decorators: [ViewDecorating]
    ) {
        self.decorators = decorators
    }
}

extension MultiViewDecorator: ViewDecorating {
    func decorate(view: UIView) {
        for decorator in decorators {
            decorator.decorate(view: view)
        }
    }
}
