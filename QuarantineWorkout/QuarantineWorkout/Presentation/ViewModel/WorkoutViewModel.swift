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
    
    let showResultsEvent = ObservableProperty<Event<FinishedPlan>>()
    
    var finishedPlan: FinishedPlan? = nil
    var finishPlanId: NSManagedObjectID? = nil
    
    var countDownTimer : Timer? = nil
    
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
        // TODO
    }
    
    func startNextWorkout(skipCurrent: Bool = false){
        if remainingWorkouts.count > 0 {
            remainingWorkoutsCount.setValue(remainingNoRest.count)
            finishedWorkoutsCount.setValue(planNoRest.count - remainingWorkouts.count)

            let workout = remainingWorkouts.remove(at: 0)

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
            
            setupTimer(workoutType: workout.type)
            saveResults()
        }else{
            saveResults()
            showResults()
        }
    }
    
    func setupTimer(workoutType: Workout.WorkoutType){
        if workoutType == .duration || workoutType == .rest{
            countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                self.addRep()
            }
        }
    }
    
    func addRep(){
        setupTimer(workoutType: currentWorkout.getValue()!.type)
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
        countDownTimer?.invalidate()
        startNextWorkout()
    }
    
    func doneAll(){
        while !remainingNoRest.isEmpty {
            finishedWorkouts.append(remainingNoRest.remove(at: 0))
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
            DataController.shared.updateBackground(id: finishPlanId, updater: { (finishedPlan: FinishedPlan) in
                let finishedWorkouts = self.finishedWorkouts.map { (workout) -> FinishedWorkout in
                    let finished = FinishedWorkout(context: DataController.shared.backgroundContext)
                    finished.name = workout.name
                    finished.reps = Int32(workout.reps ?? 0)
                    finished.duration = Int32(workout.duration ?? 0)
                    finished.type = workout.type.rawValue
                    return finished
                }
                
                finishedPlan.workouts = NSSet(array: finishedWorkouts)
                finishedPlan.calories = Int32(planCalories)
            }, errorHandler: { error in
                self.handleError(error)
            })
        }
    }
    
    func showResults(){
        showResultsEvent.setValue(Event<FinishedPlan>(data: finishedPlan))
    }
}
