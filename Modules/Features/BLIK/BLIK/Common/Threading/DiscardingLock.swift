//
//  DiscardingLock.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 15/06/2021.
//

import Foundation

/// A type that allows to run only one operation at the time.
protocol DiscardingLocking {
    typealias ReleaseBlock = () -> Void
    /// Performs operation and locks itself. Other method calls will be discarded until release block is called.
    ///
    /// - parameters:
    ///     - operation: Operation that will be performed in a lock
    func lock(operation: @escaping (@escaping ReleaseBlock) -> Void)
}


final class DiscardingLock: DiscardingLocking {
    private var isLocked = false
    private let lockQueue = DispatchQueue(
        label: "pl.santander.mobile.Blik.DiscardingLock"
    )
    
    func lock(operation: @escaping (@escaping ReleaseBlock) -> Void) {
        lockQueue.async {
            guard
                !self.isLocked
            else {
                return
            }
            
            self.isLocked = true
            operation({ [weak self] in
                guard
                    let strongSelf = self
                else {
                    return
                }
                
                strongSelf.lockQueue.async {
                    strongSelf.isLocked = false
                }
            })
        }
    }
}
