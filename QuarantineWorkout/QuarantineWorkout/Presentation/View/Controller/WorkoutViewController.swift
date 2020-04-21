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
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func showResultClicked(_ sender: Any) {
        getFlowCoordinator().showWorkoutResult(vc: self)
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
    }
    @IBAction func doneClicked(_ sender: Any) {
    }
    @IBAction func skipClicked(_ sender: Any) {
    }
    @IBAction func finishClicked(_ sender: Any) {
    }
}
