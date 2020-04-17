//
//  WeeklyChallangeFlowCoordinator.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WeeklyChallangeFlowCoordinator: BaseFlowCoordinator{
    func showWorkout(vc: BaseController){
        performSegue(source: vc, segueIdentifier: "showWorkoutSegue", flowAction: FlowPrepareData(vmFactory: { (_) in
            return WorkoutViewModel()
        }))
    }
    
    func showWorkoutResult(vc: BaseController){
        performSegue(source: vc, segueIdentifier: "showWorkoutResultSegue", flowAction: FlowPrepareData(vmFactory: { (_) in
            return WorkoutResultViewModel()
        }))
    }
}
