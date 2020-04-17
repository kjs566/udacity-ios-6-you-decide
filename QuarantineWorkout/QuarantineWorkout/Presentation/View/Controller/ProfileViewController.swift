//
//  ProfileViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ProfileViewController: TabRootViewController<ProfileViewModel, ProfileFlowCoordinator>{
    
    @IBAction func showCalendarClicked(_ sender: Any) {
        getFlowCoordinator().showCalendar(vc: self)
    }
    
    @IBAction func reloadClicked(_ sender: Any) {
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        logout()
    }
}
