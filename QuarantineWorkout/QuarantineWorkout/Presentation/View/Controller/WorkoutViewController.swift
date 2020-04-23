//
//  WorkoutViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class WorkoutViewController: BaseViewController<WorkoutViewModel, WeeklyChallangeFlowCoordinator>{
    @IBOutlet weak var remainingView: UILabel!
    @IBOutlet weak var repsView: UIButton!
    @IBOutlet weak var doneView: UIButton!
    @IBOutlet weak var skipView: UIButton!
    @IBOutlet weak var finishView: UIButton!
    @IBOutlet weak var workoutView: UILabel!
    @IBOutlet weak var tapToCountView: UILabel!
    
    override func viewDidLoad() {
        observeProperty(getVM().currentWorkout) { (workout) in
            guard let workout = workout else { return }
            
            self.workoutView.text = workout.name
        }
        
        observeProperty(getVM().remainingWorkoutsCount) { (remaining) in
            guard let remaining = remaining else { return }
            
            self.remainingView.text = String(remaining) + "Remaining"
        }
        
        observeProperty(getVM().remainingReps) { (remaining) in
            guard let remaining = remaining else { return }
            
            var title = String(remaining)
            let workoutType = self.getVM().currentWorkout.getValue()?.type
            
            if(workoutType != nil && workoutType! == .duration){
                title = title + " s"
                self.tapToCountView.isHidden = true
                self.repsView.isUserInteractionEnabled = false
            }else{
                title = title + " reps"
                self.tapToCountView.isHidden = false
                self.repsView.isUserInteractionEnabled = true
            }
            
            self.repsView.setTitle(title, for: .normal)
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
    @IBAction func repsClicked(_ sender: Any) {
        getVM().addRep()
    }
    @IBAction func doneClicked(_ sender: Any) {
        getVM().doneWorkout()
    }
    @IBAction func skipClicked(_ sender: Any) {
        getVM().skipWorkout()
    }
    @IBAction func finishClicked(_ sender: Any) {
        getVM().finishPlan()
    }
}
