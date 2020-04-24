//
//  WorkoutResultViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class WorkoutResultViewController: BaseViewController<WorkoutResultViewModel, WorkoutDetailFlowCoordinator>{
    @IBOutlet weak var caloriesView: UILabel!
    @IBOutlet weak var durationView: UILabel!
    @IBOutlet weak var repsCountView: UILabel!
    @IBOutlet weak var workoutCountView: UILabel!
    @IBOutlet weak var planTableView: WorkoutPlanTableView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        observeProperty(getVM().finishedPlan) { (plan: FinishedPlan?) in
            self.caloriesView.text = String(plan?.calories ?? 0) + " kcal"
            self.repsCountView.text = String(plan?.totalReps ?? 0)
            self.workoutCountView.text = String(plan?.workoutsCount ?? 0)
            self.durationView.text = plan?.durationAsString() ?? "0 s"
        }
        
        observeProperty(getVM().finishedWorkouts) { (workouts) in
            self.planTableView.updateWorkouts(workouts: workouts ?? [])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
