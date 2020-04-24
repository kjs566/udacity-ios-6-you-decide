//
//  WeeklyChallangeFlowCoordinator.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class WeeklyChallangeFlowCoordinator: BaseFlowCoordinator{
    func prepareEmbeddedDetail(sourceController: BaseController, segue: UIStoryboardSegue){
        if segue.identifier == "embeddedWorkoutDetailSegue"{
            prepareSegueProtocol(sourceController: sourceController, segue: segue, sender: FlowPrepareData(vmFactory: { (_) in
                return WorkoutDetailViewModel()
            }, flowCoordinatorFactory: { _ in
                WorkoutDetailFlowCoordinator()
            }))
        }
    }
}
