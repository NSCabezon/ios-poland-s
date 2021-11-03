//
//  ProgressBar+.swift
//  BLIK
//
//  Created by 186492 on 08/06/2021.
//

import UI

extension ProgressBar {
    func setRoundedCorners() {
        let cornerRadius = frame.height / 2
        layer.cornerRadius = cornerRadius
        subviews.forEach {
            $0.layer.cornerRadius = cornerRadius
            $0.subviews.forEach {
                $0.layer.cornerRadius = cornerRadius
            }
        }
    }
}
