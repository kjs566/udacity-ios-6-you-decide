//
//  WorkoutPlansViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class WorkoutPlansViewController: TabRootViewController<WorkoutPlansViewModel, WorkoutPlansFlowCoordinator>{
    
    @IBAction func legsArmsClicked(_ sender: Any) {
        getFlowCoordinator().showPlanDetail(vc: self, plan: getVM().legsPlan)
    }
}
