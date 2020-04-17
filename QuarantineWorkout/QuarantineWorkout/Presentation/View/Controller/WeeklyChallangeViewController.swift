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

class WeeklyChallangeViewController : BaseViewController<WeeklyChallangeViewModel, WeeklyChallangeFlowCoordinator>{
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBAction func startWorkoutClicked(_ sender: Any) {
        getFlowCoordinator().showWorkout(vc: self)
    }
}
