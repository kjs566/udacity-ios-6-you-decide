//
//  ProfileViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ProfileViewController: BaseViewController<ProfileViewModel, ProfileFlowCoordinator>{
    
    @IBAction func showCalendarClicked(_ sender: Any) {
        getFlowCoordinator().showCalendar(vc: self)
    }
}
