//
//  Int+Extension.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

extension Int{
    
    func asDurationString() -> String{
        let duration = self
        if duration < 60{
            return String(duration) + " s"
        }else if duration < 120 * 60{
            return String(duration/60) + " m"
        }else {
            return String(duration/60/60) + " h"
        }
    }
}
