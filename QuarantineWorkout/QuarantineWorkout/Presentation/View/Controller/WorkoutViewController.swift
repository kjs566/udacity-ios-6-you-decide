//
//  WorkoutViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class WorkoutViewController: BaseViewController<WorkoutViewModel, WeeklyChallangeFlowCoordinator>{
    
    @IBAction func showResultClicked(_ sender: Any) {
        getFlowCoordinator().showWorkoutResult(vc: self)
    }
}
