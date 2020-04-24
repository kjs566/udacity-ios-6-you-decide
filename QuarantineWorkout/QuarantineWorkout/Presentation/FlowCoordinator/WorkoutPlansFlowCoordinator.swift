//
//  WorkoutPlansFlowCoordinator.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class WorkoutPlansFlowCoordinator: BaseFlowCoordinator{
    func showPlanDetail(vc: BaseController, plan: WorkoutPlan){
        performSegue(source: vc, segueIdentifier: "showWorkoutDetailSegue", flowAction: FlowPrepareData(vmFactory: { (_) in
                return WorkoutDetailViewModel(plan: plan)
        }, flowCoordinatorFactory: { _ in
            return WorkoutDetailFlowCoordinator()
        }))
    }
}
