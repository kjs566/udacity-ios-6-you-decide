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
    @IBAction func startWorkoutClicked(_ sender: Any) {
        getFlowCoordinator().showWorkout(vc: self)
    }
    @IBAction func reloadClicked(_ sender: Any) {
    }
    @IBAction func logoutClicked(_ sender: Any) {
        logout()
    }
}
