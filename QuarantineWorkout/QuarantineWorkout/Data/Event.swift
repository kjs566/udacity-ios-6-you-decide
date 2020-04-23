//
//  ObservableEvent.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 23/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

public class Event<T>{
    var handled = false
    var data: T? = nil
    
    init(data: T?) {
        self.data = data
    }
    
    func handle(_ handler: (T?)->Void){
        if !handled{
            handled = true
            handler(data)
        }
    }
}
