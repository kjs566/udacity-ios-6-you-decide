//
//  WorkoutDetailFlowCoordinator.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WorkoutDetailFlowCoordinator: BaseFlowCoordinator{
    func showWorkout(vc: BaseController, plan: WorkoutPlan){
        performSegue(source: vc, segueIdentifier: "showWorkoutSegue", flowAction: FlowPrepareData(vmFactory: { (_) in
            return WorkoutViewModel(plan: plan)
        }))
    }
    
    func showWorkoutResult(vc: BaseController, finishedPlan: FinishedPlan?){
        performSegue(source: vc, segueIdentifier: "showWorkoutResultSegue", flowAction: FlowPrepareData(vmFactory: { (_) in
            return WorkoutResultViewModel(finishedPlan: finishedPlan)
        }))
    }
}
