//
//  SelectableItem.swift
//  PLScenes
//
//  Created by 185167 on 10/02/2022.
//

public protocol SelectableItem: Equatable {
    var identifier: String { get }
    var name: String { get }
}
