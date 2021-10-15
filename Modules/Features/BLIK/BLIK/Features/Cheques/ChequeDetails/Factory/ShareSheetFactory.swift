//
//  ShareSheetFactory.swift
//  BLIK
//
//  Created by 186491 on 23/06/2021.
//

import UIKit

public enum ShareSheetType {
    case text(String)
}

public protocol ShareSheetProducing {
    func create(type: ShareSheetType) -> UIViewController
}

public final class ShareSheetFactory: ShareSheetProducing {
    public init() {}
    
    public func create(type: ShareSheetType) -> UIViewController {
        var activityItems = [Any]()
        switch type {
        case .text(let text):
            activityItems.append(text)
        }
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
}
