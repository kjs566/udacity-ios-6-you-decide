//
//  FinishedPlan+Extension.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

extension FinishedPlan{
    func durationAsString() -> String{
        return Int(self.duration).asDurationString()
    }
}
