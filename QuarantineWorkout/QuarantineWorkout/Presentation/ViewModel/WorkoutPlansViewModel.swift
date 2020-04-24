//
//  WorkoutPlansViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WorkoutPlansViewModel : TabRootViewModel{
    let legsPlan = WorkoutPlan(difficulty: "medium", totalTime: "10 min", calories: 198, workouts: [
            Workout(name: "Squat", type: .reps, duration: nil, reps: 30)
        ]
        , bodyParts: "Legs, amrs")
}
