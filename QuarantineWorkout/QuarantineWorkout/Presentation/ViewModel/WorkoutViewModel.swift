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
    
    var currentIndex = -1
    let currentWorkout = ObservableProperty<Workout>()
    
    let remainingReps = ObservableProperty<Int>()
    let finishedReps = ObservableProperty<Int>()
    
    let remainingWorkouts = ObservableProperty<Int>()
    let finishedWorkouts = ObservableProperty<Int>()
    
    init(plan: WorkoutPlan) {
        self.plan = plan
        super.init()
        startNextWorkout()
    }
    
    func startNextWorkout(){
        if currentIndex < plan.workouts.count  - 1{
            currentIndex = currentIndex + 1
            let workout = plan.workouts[currentIndex]
        }else{
            saveResults()
            showResults()
        }
    }
    
    func skipWorkout(){
        
    }
    
    func doneAll(){
        
    }
    
    func finishPlan(){
        
    }
    
    func addRep(){
        
    }
    
    func saveResults(){
        
    }
    
    func showResults(){
        
    }
}
