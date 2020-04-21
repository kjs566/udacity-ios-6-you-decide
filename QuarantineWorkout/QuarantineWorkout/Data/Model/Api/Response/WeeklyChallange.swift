//
//  WeeklyChallange.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 21/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct WorkoutPlan: Codable{
    let difficulty: String?
    let totalTime: String?
    let calories: Int?
    let plan: [Workout]?
    let bodyParts: String?
}
