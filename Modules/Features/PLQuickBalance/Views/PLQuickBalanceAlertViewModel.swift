//
//  PLQuickBalanceAlertViewModel.swift
//  PLQuickBalance
//
//  Created by 185860 on 29/04/2022.
//

import Foundation

class PLQuickBalanceAlertViewModel {
    let image: UIImage
    let title: String
    let subtitle: String
    let cancelButtonTitle: String
    let acceptButtonTitle: String
    
    init(image: UIImage,
         title: String,
         subtitle: String,
         cancelButtonTitle: String,
         acceptButtonTitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.cancelButtonTitle = cancelButtonTitle
        self.acceptButtonTitle = acceptButtonTitle
    }
    
}
