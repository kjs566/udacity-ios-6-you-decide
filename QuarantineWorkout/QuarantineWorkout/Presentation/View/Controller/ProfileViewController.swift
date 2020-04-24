//
//  ProfileViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: TabRootViewController<ProfileViewModel, ProfileFlowCoordinator>{
    @IBOutlet weak var caloriesView: UILabel!
    @IBOutlet weak var plansView: UILabel!
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeProperty(getVM().logoutState) { (value) in
            value?.handle(success: { (_) in
                self.hideLoading()
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }, error: { (error) in
                self.hideLoading()
                self.handleError(error)
            }, loading: {
                self.showLoading()
            })
        }
        
        observeProperty(getVM().finishedPlans) { (finishedPlans) in
            self.plansView.text = String(finishedPlans ?? 0)
        }
        
        observeProperty(getVM().totalCalories) { (totalCalories) in
            self.caloriesView.text = String(totalCalories ?? 0) + " kcal"
        }
        
        observeProperty(getVM().state) { (state) in
            
        }
    }
    
    func logout(){
        getVM().logout()
    }
}
