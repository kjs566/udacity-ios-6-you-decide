//
//  WorkoutResultViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WorkoutResultViewModel : BaseViewModel{
    let finishedPlan =  ObservableProperty<FinishedPlan>()
    let finishedWorkouts = ObservableProperty<[Workout]>()
    
    init(finishedPlan: FinishedPlan?) {
        self.finishedPlan.setValue(finishedPlan)
        finishedWorkouts.setValue(finishedPlan?.workouts?.allObjects.map({ (finished) -> Workout in
            return Workout.fromFinishedWorkout(finishedWorkout: finished as! FinishedWorkout)
        }))
    }
    
}
