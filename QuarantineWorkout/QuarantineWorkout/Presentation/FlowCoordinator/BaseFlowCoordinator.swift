//
//  BaseFlowCoordinator.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 16/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

open class BaseFlowCoordinator{
    func performSegue<VM: BaseViewModel, FC: BaseFlowCoordinator, VC: BaseViewController<VM, FC>, D, VMTarget: BaseViewModel>(source: VC, segueIdentifier: String, flowAction: FlowData<VMTarget, D>){
        source.performSegue(withIdentifier: segueIdentifier, sender: flowAction)
    }
    
    func performSegueNewCoordinator<VM: BaseViewModel, FC: BaseFlowCoordinator, VC: BaseViewController<VM, FC>, D, VMTarget: BaseViewModel>(source: VC, segueIdentifier: String, flowAction: FlowData<VMTarget, D>){
        source.performSegue(withIdentifier: segueIdentifier, sender: flowAction)
    }
    
    func prepareSegue(segue: UIStoryboardSegue, sender: Any?){
        if sender is FlowData<BaseViewModel, Any> {
            let flowData = sender as! FlowData<BaseViewModel, Any>
            print("Preparing flow action")
            
            let vc = segue.destination as! BaseViewController
            vc.viewModel = flowData.vmFactory(flowData.data)
        } else if sender is FlowDataNewCoordinator<BaseFlowCoordinator, Any> {
            let flowData = sender as! FlowDataNewCoordinator<BaseFlowCoordinator, Any>
            print("Preparing flow action")
            
            let vc = segue.destination
            let fc = flowData.flowCoordinatorFactory(flowData.data)
            flowData.setupVC(fc, flowData.data, vc)
        }
    }
    
        
    struct FlowData<VM: BaseViewModel, D>{
        let vmFactory: (D?)->VM
        let data: D?
    }
    
    struct FlowDataNewCoordinator<FC: BaseFlowCoordinator, D>{
        let flowCoordinatorFactory: (D?)->FC
        let setupVC: (FC, D, UIViewController)->Void
        let data: D?
    }
}
