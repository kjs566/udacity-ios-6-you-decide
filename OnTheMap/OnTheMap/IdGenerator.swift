//
//  IdGenerator.swift
//  OnTheMap
//
//  Created by Jan Skála on 31/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class IdGenerator{
    static let shared = IdGenerator()
    private let lock = DispatchSemaphore(value: 1)
    
    private var counter : UInt64 = UInt64.min
    
    private init(){}
    
    public func generateUniqueId() -> String{
        lock.wait()
        defer{
            lock.signal()
        }
        counter += 1
        return String(counter)
    }
}
