//
//  BottomSheetErrorViewModel.swift
//  Santander
//
//  Created by Daniel Gómez Barroso on 10/11/21.
//

import UI

public final class BottomSheetErrorViewModel {
    let imageKey: String
    let titleKey: String
    let textKey: String
    let leftButtonKey: String?
    let mainButtonKey: String
    
    public init(imageKey: String,
                titleKey: String,
                textKey: String,
                leftButtonKey: String? = nil,
                mainButtonKey: String) {
        self.imageKey = imageKey
        self.titleKey = titleKey
        self.textKey = textKey
        self.leftButtonKey = leftButtonKey
        self.mainButtonKey = mainButtonKey
    }
}
