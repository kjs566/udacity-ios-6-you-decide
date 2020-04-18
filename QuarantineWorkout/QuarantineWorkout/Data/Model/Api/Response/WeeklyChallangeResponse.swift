//
//  WeeklyChallangeResponse.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct WeeklyChallangeResponse: Codable{
    let weeklyChallange: WeeklyChallange
    
    struct WeeklyChallange: Codable{
        let difficulty: String
        let totalTime: String
        let calories: Int
        let plan: [Workout]
    }
    
    struct Workout: Codable{
        enum WorkoutType: String, Codable{
            case duration = "duration"
            case reps = "reps"
            case rest = "rest"
        }
        
        let name: String
        let type: WorkoutType
        let duration: Int?
        let reps: Int?
    }
}
