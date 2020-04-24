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
    
    lazy var authRepository = AuthRepository()
    lazy var apiRepository = ApiRepository.shared
    
    init(storyboard: UIStoryboard, window: UIWindow?){
        self.storyboard = storyboard
        self.window = window
    }
    
    func start(){
        window?.rootViewController = createLoginController()
        window?.makeKeyAndVisible()
    }
    
    func showMain<VM : BaseViewModel, FC: BaseFlowCoordinator, VC: BaseViewController<VM, FC>>(source: VC){
        performSegue(source: source, segueIdentifier: "showMainSegue", flowAction: FlowPrepareData(vmFactory: { (_) in
                return BaseViewModel()
        }, setupVC: { (vm, data, vc) in            
            // TODO MAKE UNIVERSAL
            let tabCtrl = vc as! UITabBarController
            for controller in tabCtrl.customizableViewControllers!{
                let navVC = controller as! UINavigationController
                let topVC = navVC.topViewController
                
                if let weeklyChallangeVC = topVC as? WeeklyChallangeViewController{
                    self.prepareDestination(targetController: weeklyChallangeVC, data: FlowPrepareData(vmFactory: { _ in
                        return WeeklyChallangeViewModel(
                            logoutUC: LogoutUseCase(authRepo: self.authRepository),
                            getWeeklyChallangeUC: GetWeeklyChallangeUseCase(apiRepo: self.apiRepository)
                            
                        )
                    }, flowCoordinatorFactory: { (_) -> Any? in
                        return WeeklyChallangeFlowCoordinator()
                    }))
                } else if let plansVC = topVC as? WorkoutPlansViewController{
                    self.prepareDestination(targetController: plansVC, data: FlowPrepareData(vmFactory: { _ in
                        return WorkoutPlansViewModel(logoutUC: LogoutUseCase(authRepo: self.authRepository))
                    }, flowCoordinatorFactory: { _ in
                        return WorkoutPlansFlowCoordinator()
                    }))
                } else if let profileVC = topVC as? ProfileViewController{
                    self.prepareDestination(targetController: profileVC, data: FlowPrepareData(vmFactory: { _ in
                        return ProfileViewModel(logoutUC: LogoutUseCase(authRepo: self.authRepository), getEmailUC: GetUserEmailUseCase(authRepository: self.authRepository))
                    }, flowCoordinatorFactory: { (_) -> Any? in
                        return ProfileFlowCoordinator()
                    }))
                }
            }
        }))
    }
    
    func showSignUp<VM : BaseViewModel, FC: BaseFlowCoordinator, VC: BaseViewController<VM, FC>>(source: VC){
        performSegue(source: source, segueIdentifier: "showSignUpSegue", flowAction: FlowPrepareData(vmFactory: { (_) in
            return SignUpViewModel(signUpUseCase: SignUpUseCase(authRepo: self.authRepository))
        }, data: None.NONE, setupVC: { (_, _, vc) in
            //vc.modalPresentationStyle = .overFullScreen
        }))
    }
    
    private func createLoginController() -> LoginViewController{
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        vc.viewModel = LoginViewModel(loginUC: LoginUseCase(authRepo: self.authRepository))
        vc.flowCoordinator = self

        return vc
    }
}
