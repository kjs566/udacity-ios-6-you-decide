//
//  WorkoutViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WorkoutViewModel: BaseViewModel{
    let plan : WorkoutPlan
    var remainingWorkouts: [Workout]
    var remainingNoRest: [Workout]
    var finishedWorkouts: [Workout] = []
    
    let currentWorkout = ObservableProperty<Workout>()
    
    let remainingReps = ObservableProperty<Int>()
    let finishedReps = ObservableProperty<Int>()
    
    let remainingWorkoutsCount = ObservableProperty<Int>()
    let finishedWorkoutsCount = ObservableProperty<Int>()
    
    let workoutType = ObservableProperty<Workout.WorkoutType>()
    
    let planNoRest: [Workout]
    
    init(plan: WorkoutPlan) {
        self.plan = plan
        self.remainingWorkouts = plan.workouts
        self.planNoRest = plan.getWorkoutWithoutRest()
        self.remainingNoRest = planNoRest
        super.init()
        startNextWorkout()
    }
    
    func startNextWorkout(skipCurrent: Bool = false){
        if remainingWorkouts.count > 0 {
            let removed = remainingWorkouts.remove(at: 0)
            if skipCurrent {
                let finished: Workout
                if removed.type == .duration {
                    finished = removed.copy(duration: finishedReps.getValue())
                } else {
                    finished = removed.copy(reps: finishedReps.getValue())
                }
                finishedWorkouts.append(finished)
            } else {
                finishedWorkouts.append(removed)
            }
            remainingNoRest = remainingWorkouts.filter({ (workout) -> Bool in
                workout.type != .rest
            })
        
            let workout = plan.workouts.first!
            
            workoutType.setValue(workout.type)
            currentWorkout.setValue(workout)
            
            remainingReps.setValue(remainingNoRest.count)
            finishedReps.setValue(0)
            
            remainingWorkoutsCount.setValue(remainingWorkouts.count)
            finishedWorkoutsCount.setValue(planNoRest.count - remainingWorkouts.count)
        }else{
            saveResults()
            showResults()
        }
    }
    
    func addRep(){
        let current = remainingReps.getValue()!
        if current > 0{
            remainingReps.setValue(current - 1)
            finishedReps.setValue(finishedReps.getValue()! + 1)
        }
    }
    
    func skipWorkout(){
        startNextWorkout(skipCurrent: true)
    }
    
    func doneWorkout(){
        startNextWorkout()
    }
    
    func doneAll(){
        while !remainingWorkouts.isEmpty {
            finishedWorkouts.append(remainingWorkouts.remove(at: 0))
        }
        saveResults()
        showResults()
    }
    
    func finishPlan(){
        saveResults()
        showResults()
    }
    
    func saveResults(){
        
    }
    
    func showResults(){
        
    }
}
