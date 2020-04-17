//
//  InitialFlowCoordinator.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 16/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class InitialFlowCoordinator: BaseFlowCoordinator{
    let storyboard: UIStoryboard
    let window: UIWindow?
    
    init(storyboard: UIStoryboard, window: UIWindow?){
        self.storyboard = storyboard
        self.window = window
    }
    
    func start(){
        window?.rootViewController = createLoginController()
        window?.makeKeyAndVisible()
    }
    
    func showMain<VM : BaseViewModel, FC: BaseFlowCoordinator, VC: BaseViewController<VM, FC>>(source: VC){
        performSegue(source: source, segueIdentifier: "showMainSegue", flowAction: FlowData(vmFactory: { (_: None?) in
                return BaseViewModel()
        }, data: None.NONE))
    }
    
    private func createLoginController() -> LoginViewController{
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        vc.viewModel = LoginViewModel(loginUC: LoginUseCase(authRepo: AuthRepository()))
        vc.flowCoordinator = self

        return vc
    }
}
