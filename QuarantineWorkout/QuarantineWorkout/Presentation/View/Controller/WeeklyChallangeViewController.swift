//
//  LocationsMapViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class WeeklyChallangeViewController : TabRootViewController<WeeklyChallangeViewModel, WeeklyChallangeFlowCoordinator>{
    
    @IBOutlet weak var durationView: UILabel!
    @IBOutlet weak var bodyPartsView: UILabel!
    @IBOutlet weak var caloriesView: UILabel!
    @IBOutlet weak var totalWorkoutsView: UILabel!
    
    @IBOutlet weak var workoutTableView: WorkoutPlanTableView!
    
    var plan: WorkoutPlan? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeProperty(getVM().weeklyChallange){ state in
            state?.handle(success: { (response) in
                self.hideLoading()
                self.setupViews(plan: response!.weeklyChallange)
            }, error: { (error) in
                self.hideLoading()
                self.handleError(error)
            }, loading: {
                self.showLoading(message: "Loading weekly challange...")
            })
        }
    }
    
    func setupViews(plan: WorkoutPlan){
        self.plan = plan

        caloriesView.text = String(plan.calories) + " kcal"
        durationView.text = plan.totalTime
        bodyPartsView.text = plan.bodyParts
        
        totalWorkoutsView.text = String(plan.getWorkoutWithoutRest().count)
        workoutTableView.updateWorkouts(workouts: plan.getWorkoutWithoutRest())
    }
    
    @IBAction func startWorkoutClicked(_ sender: Any) {
        getFlowCoordinator().showWorkout(vc: self, plan: plan!)
    }
    @IBAction func reloadClicked(_ sender: Any) {
        getVM().loadWeeklyChallange()
    }
    @IBAction func logoutClicked(_ sender: Any) {
        logout()
    }
}
