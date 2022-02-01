//
//  Async.swift
//  Account
//
//  Created by Juan Carlos López Robles on 12/22/21.
//

import Foundation

func Async(queue: DispatchQueue, completion: @escaping () -> Void) {
    queue.async {
        completion()
    }
}
