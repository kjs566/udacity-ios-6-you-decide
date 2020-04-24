//
//  WorkoutViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import CoreData

class WorkoutViewModel: BaseViewModel{
    let error = ObservableProperty<Event<Error>>()
    let workoutStart = NSDate().timeIntervalSince1970
    
    let plan : WorkoutPlan
    var remainingWorkouts: [Workout]
    var remainingNoRest: [Workout]
    var finishedWorkouts: [Workout] = []
    
    var totalReps = 0
    
    let currentWorkout = ObservableProperty<Workout>()
    
    let remainingReps = ObservableProperty<Int>()
    let finishedReps = ObservableProperty<Int>()
    
    let remainingWorkoutsCount = ObservableProperty<Int>()
    let finishedWorkoutsCount = ObservableProperty<Int>()
    
    let workoutType = ObservableProperty<Workout.WorkoutType>()
    
    let planNoRest: [Workout]
    
    let showResultsEvent = ObservableProperty<Event<FinishedPlan>>()
    
    var finishedPlan: FinishedPlan? = nil
    var finishPlanId: NSManagedObjectID? = nil
    
    var countDownTimer : Timer? = nil
    
    var finishedWorkoutReps: [Int] = []
    
    init(plan: WorkoutPlan) {
        self.plan = plan
        self.remainingWorkouts = plan.workouts
        self.planNoRest = plan.getWorkoutWithoutRest()
        self.remainingNoRest = planNoRest
        super.init()
        startNextWorkout()
        
        finishPlanId = DataController.shared.createAndSave(initializer: { (finished: FinishedPlan) in
            finished.calories = Int32(self.plan.calories)
            finished.timestamp = Int64(NSDate().timeIntervalSince1970)
            finished.workouts = []
            finished.duration = 0
            
            self.finishedPlan = finished
        }, errorHandler: { (error) in
            self.handleError(error)
        })
    }
    
    func handleError(_ error: Error?){
        self.error.setValue(Event(data: error))
    }
    
    func startNextWorkout(skipCurrent: Bool = false){
        if remainingWorkouts.count > 0 {
            remainingWorkoutsCount.setValue(remainingNoRest.count)
            finishedWorkoutsCount.setValue(planNoRest.count - remainingWorkouts.count)

            let workout = remainingWorkouts.remove(at: 0)

            finishCurrentWorkout()
            remainingNoRest = remainingWorkouts.filter({ (workout) -> Bool in
                workout.type != .rest
            })
            
            if workout.type != .rest{
                finishedWorkoutReps.append(0)
            }
                    
            workoutType.setValue(workout.type)
            currentWorkout.setValue(workout)
            
            remainingReps.setValue(workout.reps ?? workout.duration)
            finishedReps.setValue(0)
            
            setupTimer(workoutType: workout.type)
            saveResults()
        }else{
            saveResults()
            showResults()
        }
    }
    
    func finishCurrentWorkout(skipCurrent: Bool = false){
        if let previous = currentWorkout.getValue(), previous.type != .rest{
            if skipCurrent {
                let finished: Workout
                if previous.type == .duration {
                    finished = previous.copy(duration: finishedReps.getValue())
                } else {
                    finished = previous.copy(reps: finishedReps.getValue())
                }
                
                finishedWorkouts.append(finished)
            } else {
                if previous.type == .reps{
                    totalReps = totalReps + (remainingReps.getValue() ?? 0)
                }
                
                if previous.type == .reps || previous.type == .duration{
                    addRepsToWorkout(remainingReps.getValue() ?? 0)
                }
                finishedWorkouts.append(previous)
            }
        }
    }
    
    func addRepsToWorkout(_ reps: Int){
        let current = finishedWorkoutReps.last ?? 0
        let new = current + reps
        finishedWorkoutReps.append(new)
    }
    
    func setupTimer(workoutType: Workout.WorkoutType){
        if workoutType == .duration || workoutType == .rest{
            countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                self.addRep()
            }
        }
    }
    
    func addRep(){
        guard let currentWorkout = currentWorkout.getValue() else { return }
        setupTimer(workoutType: currentWorkout.type)
        let current = remainingReps.getValue()!
        if currentWorkout.type == .reps{
            totalReps = totalReps + 1
        }
        if currentWorkout.type == .reps || currentWorkout.type == .duration{
            addRepsToWorkout(1)
        }
        if current > 1{
            remainingReps.setValue(current - 1)
            finishedReps.setValue(finishedReps.getValue()! + 1)
        }else{
            doneWorkout()
        }
        
        saveResults() // Might be to much - saving after each one rep/second...
    }
    
    func skipWorkout(){
        startNextWorkout(skipCurrent: true)
    }
    
    func doneWorkout(){
        countDownTimer?.invalidate()
        startNextWorkout()
    }
    
    func doneAll(){
        finishCurrentWorkout()
        while !remainingNoRest.isEmpty {
            let workout = remainingNoRest.remove(at: 0)
            totalReps = totalReps + (workout.reps ?? 0)
            finishedWorkouts.append(workout)
            finishedWorkoutReps.append(workout.reps ?? workout.duration!)
        }
        saveResults()
        showResults()
    }
    
    func finishPlan(){
        saveResults()
        showResults()
    }
    
    func saveResults(){
        DispatchQueue.global(qos: .background).async {
            let totalCalories = self.plan.calories
            let caloriesPerWorkout = totalCalories / self.plan.getWorkoutWithoutRest().count
            let planCalories = caloriesPerWorkout * self.finishedWorkouts.count
            
            guard let finishPlanId = self.finishPlanId else { return }
            DataController.shared.updateBackground(id: finishPlanId, updater: { (finishedPlan: FinishedPlan) in // Would be nice to move this to repository...
                var finishedWorkouts = self.finishedWorkouts.enumerated().map { (index, workout) -> FinishedWorkout in
                    let finished = FinishedWorkout(context: DataController.shared.backgroundContext)
                    finished.name = workout.name
                    finished.reps = Int32(workout.type == .reps ? (self.finishedWorkoutReps[index] ) : 0)
                    finished.duration = Int32(workout.type == .duration ? (self.finishedWorkoutReps[index] ) : 0)
                    finished.type = workout.type.rawValue
                    finished.itemIndex = Int64(index)
                    return finished
                }
                
                
                if let workout = self.currentWorkout.getValue(), let currentReps = self.finishedReps.getValue(){
                    let finished = FinishedWorkout(context: DataController.shared.backgroundContext)
                    finished.name = workout.name
                    finished.reps = Int32(currentReps)
                    finished.duration = Int32(currentReps)
                    finished.type = workout.type.rawValue
                    finished.itemIndex = Int64(finishedWorkouts.count)
                    finishedWorkouts.append(finished)
                }
                
                finishedPlan.workouts = NSSet(array: finishedWorkouts)
                finishedPlan.calories = Int32(planCalories)
                finishedPlan.workoutsCount = Int64(finishedWorkouts.count)
                finishedPlan.totalReps = Int64(self.totalReps)
                
                let timeDiff = NSDate().timeIntervalSince1970 - self.workoutStart
                finishedPlan.duration = Int64(timeDiff)
            }, errorHandler: { error in
                self.handleError(error)
            })
        }
    }
    
    func showResults(){
        showResultsEvent.setValue(Event<FinishedPlan>(data: finishedPlan))
    }
}
