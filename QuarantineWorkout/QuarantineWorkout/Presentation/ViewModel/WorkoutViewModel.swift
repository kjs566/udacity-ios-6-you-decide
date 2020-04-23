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
    
    let showResultsEvent = ObservableProperty<Event>()
    let workoutUuid = UUID.init()
    
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
            remainingWorkoutsCount.setValue(remainingNoRest.count)
            finishedWorkoutsCount.setValue(planNoRest.count - remainingWorkouts.count)

            let workout = remainingWorkouts.remove(at: 0)

            if let previous = currentWorkout.getValue(){
                if skipCurrent {
                    let finished: Workout
                    if previous.type == .duration {
                        finished = previous.copy(duration: finishedReps.getValue())
                    } else {
                        finished = previous.copy(reps: finishedReps.getValue())
                    }
                    finishedWorkouts.append(finished)
                } else {
                    finishedWorkouts.append(previous)
                }
            }
            remainingNoRest = remainingWorkouts.filter({ (workout) -> Bool in
                workout.type != .rest
            })
                    
            workoutType.setValue(workout.type)
            currentWorkout.setValue(workout)
            
            remainingReps.setValue(workout.reps ?? workout.duration)
            finishedReps.setValue(0)
        }else{
            saveResults()
            showResults()
        }
    }
    
    func addRep(){
        let current = remainingReps.getValue()!
        if current > 1{
            remainingReps.setValue(current - 1)
            finishedReps.setValue(finishedReps.getValue()! + 1)
        }else{
            doneWorkout()
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
        showResultsEvent.setValue(Event())
    }
}
