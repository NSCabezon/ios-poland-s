//
//  IntExtension.swift
//  Account
//
//  Created by 187831 on 12/03/2022.
//

import PLScenes

extension Int: SelectableItem {
    public var identifier: String {
        return UUID().uuidString
    }
    
    public var name: String {
        return "\(self)"
    }
}
