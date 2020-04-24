//
//  WorkoutDetailViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WorkoutDetailViewModel: BaseViewModel{
    let plan = ObservableProperty<WorkoutPlan>()
    
    init(plan: WorkoutPlan? = nil) {
        super.init()
        self.plan.setValue(plan)
    }
    
    func setPlan(_ plan: WorkoutPlan?){
        self.plan.setValue(plan)
    }
}
