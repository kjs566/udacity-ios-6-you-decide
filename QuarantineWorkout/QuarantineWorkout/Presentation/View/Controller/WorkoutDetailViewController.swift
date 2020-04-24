//
//  WorkoutDetailViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class WorkoutDetailViewController: BaseViewController<WorkoutDetailViewModel, WorkoutDetailFlowCoordinator>{
    @IBOutlet weak var durationView: UILabel!
    @IBOutlet weak var bodyPartsView: UILabel!
    @IBOutlet weak var caloriesView: UILabel!
    @IBOutlet weak var totalWorkoutsView: UILabel!
    
    @IBOutlet weak var workoutTableView: WorkoutPlanTableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        observeProperty(getVM().plan) { (plan) in
            guard let plan = plan else { return }
            self.setupViews(plan: plan)
        }
    }
    
    func setPlan(plan: WorkoutPlan){
        getVM().setPlan(plan)
    }
    
    private func setupViews(plan: WorkoutPlan){
        caloriesView.text = String(plan.calories) + " kcal"
        durationView.text = plan.totalTime
        bodyPartsView.text = plan.bodyParts
        
        totalWorkoutsView.text = String(plan.getWorkoutWithoutRest().count)
        workoutTableView.updateWorkouts(workouts: plan.getWorkoutWithoutRest())
    }
    
    @IBAction func startWorkoutClicked(_ sender: Any) {
        guard let plan = getVM().plan.getValue() else { return }
        getFlowCoordinator().showWorkout(vc: self, plan: plan)
    }
}
