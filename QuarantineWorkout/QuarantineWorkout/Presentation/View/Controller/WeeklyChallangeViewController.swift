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
    var workoutDetailVC: WorkoutDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutDetailVC = children.first as? WorkoutDetailViewController
        observeProperty(getVM().weeklyChallange){ state in
            state?.handle(success: { (response) in
                self.hideLoading()
                self.workoutDetailVC.setPlan(plan: response!.weeklyChallange)
            }, error: { (error) in
                self.hideLoading()
                self.handleError(error)
            }, loading: {
                self.showLoading()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embeddedWorkoutDetailSegue"{
            getFlowCoordinator().prepareEmbeddedDetail(sourceController: self, segue: segue)
        }else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction func reloadClicked(_ sender: Any) {
        getVM().loadWeeklyChallange()
    }
}
