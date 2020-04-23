//
//  Workout.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 18/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

struct Workout: Codable{
    public enum WorkoutType: String, Codable{
        case duration = "duration"
        case reps = "reps"
        case rest = "rest"
    }
    
    let name: String
    let type: WorkoutType
    let duration: Int?
    let reps: Int?
    
    func copy(name: String? = nil, type: WorkoutType? = nil, duration: Int? = nil, reps: Int? = nil) -> Workout{
        return Workout(name: name ?? self.name, type: type ?? self.type, duration: duration ?? self.duration, reps: reps ?? self.reps)
    }
    
    static func fromFinishedWorkout(finishedWorkout: FinishedWorkout) -> Workout{
        return Workout(name: finishedWorkout.name ?? "", type: WorkoutType.init(rawValue: finishedWorkout.type ?? "rest") ?? .rest, duration: Int(finishedWorkout.duration) ?? 0, reps: Int(finishedWorkout.reps) ?? 0)
    }
}
