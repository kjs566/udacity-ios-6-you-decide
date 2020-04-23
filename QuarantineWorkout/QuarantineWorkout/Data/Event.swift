//
//  ObservableEvent.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 23/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

public class Event{
    var handled = false
    
    func handle(handler: ()->Unit){
        if !handled{
            handled = true
            handler()
        }
    }
}
