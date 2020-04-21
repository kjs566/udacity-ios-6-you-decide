//
//  WorkoutResultViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class WorkoutResultViewController: BaseViewController<WorkoutResultViewModel, MainFlowCoordinator>{
    @IBOutlet weak var caloriesView: UILabel!
    @IBOutlet weak var durationView: UILabel!
    @IBOutlet weak var repsCountView: UILabel!
    @IBOutlet weak var workoutCountView: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    @IBAction func doneClicked(_ sender: Any) {
    }
}
