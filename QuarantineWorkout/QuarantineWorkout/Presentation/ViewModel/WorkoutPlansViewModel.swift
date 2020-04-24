//
//  WorkoutPlansViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WorkoutPlansViewModel : TabRootViewModel{
    let legsPlan = WorkoutPlan(difficulty: "medium", totalTime: "15 min", calories: 198, workouts: [
            Workout(name: "Warm-up: Jumping jacks", type: .duration, duration: 60, reps: nil),
            Workout(name: "Squat", type: .reps, duration: nil, reps: 30),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Lunge", type: .reps, duration: nil, reps: 30),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Glute bridge", type: .reps, duration: nil, reps: 20),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Lateral Lunge", type: .reps, duration: nil, reps: 20),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Jumping Squat", type: .reps, duration: nil, reps: 20),
            Workout(name: "Cool-down: Jumping jacks", type: .duration, duration: 60, reps: nil),
        ]
        , bodyParts: "Legs, amrs")
    
    let absPlan = WorkoutPlan(difficulty: "easy", totalTime: "15 min", calories: 126, workouts: [
            Workout(name: "Warm-up: Jumping jacks", type: .duration, duration: 60, reps: nil),
            Workout(name: "Crunches", type: .reps, duration: nil, reps: 30),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Plank", type: .duration, duration: 30, reps: nil),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Side-plank", type: .duration, duration: 30, reps: nil),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Sit-ups", type: .reps, duration: nil, reps: 20),
            Workout(name: "Cool-down: Jumping jacks", type: .duration, duration: 60, reps: nil),
        ]
        , bodyParts: "Abs, back")
    
    let allPlan = WorkoutPlan(difficulty: "hard", totalTime: "20 min", calories: 312, workouts: [
            Workout(name: "Warm-up: Jumping jacks", type: .duration, duration: 60, reps: nil),
            Workout(name: "Squat", type: .reps, duration: nil, reps: 30),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Lunge", type: .reps, duration: nil, reps: 30),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Glute bridge", type: .reps, duration: nil, reps: 20),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Lateral Lunge", type: .reps, duration: nil, reps: 20),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Jumping Squat", type: .reps, duration: nil, reps: 20),
            Workout(name: "Crunches", type: .reps, duration: nil, reps: 30),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Plank", type: .duration, duration: 30, reps: nil),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Side-plank", type: .duration, duration: 30, reps: nil),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Sit-ups", type: .reps, duration: nil, reps: 20),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Mountain-climbers", type: .reps, duration: nil, reps: 20),
            Workout(name: "Cool-down: Jumping jacks", type: .duration, duration: 60, reps: nil),
        ]
        , bodyParts: "All body")
    
    let fatPlan = WorkoutPlan(difficulty: "medium", totalTime: "18 min", calories: 238, workouts: [
            Workout(name: "Warm-up: Jumping jacks", type: .duration, duration: 60, reps: nil),
            Workout(name: "March in place", type: .duration, duration: 60, reps: nil),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Squat", type: .reps, duration: nil, reps: 30),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "But-kicks", type: .reps, duration: nil, reps: 20),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Jumping Squat", type: .reps, duration: nil, reps: 20),
            Workout(name: "Rest", type: .rest, duration: 15, reps: nil),
            Workout(name: "Mountain-climbers", type: .reps, duration: nil, reps: 20),
            Workout(name: "Cool-down: Jumping jacks", type: .duration, duration: 60, reps: nil),
        ]
        , bodyParts: "All body")
}
