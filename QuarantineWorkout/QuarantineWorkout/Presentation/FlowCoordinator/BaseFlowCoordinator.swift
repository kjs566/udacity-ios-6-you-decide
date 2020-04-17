//
//  BaseFlowCoordinator.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 16/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

public protocol BaseFlowCoordinator{
    //func getRootViewController() -> UIViewController
}

extension BaseFlowCoordinator{
    func performSegue(source: BaseController, segueIdentifier: String, flowAction: FlowPrepareData){
        source.performSegue(withIdentifier: segueIdentifier, sender: flowAction)
    }
    
    func performSegueNewCoordinator(source: BaseController, segueIdentifier: String, flowAction: FlowPrepareData){
        source.performSegue(withIdentifier: segueIdentifier, sender: flowAction)
    }
    
    func prepareSegue(sourceController: BaseController, segue: UIStoryboardSegue, sender: Any?){
        guard let data = sender as? FlowPrepareData else {
            print("WARNING: " + "Segue performed without flow coordinator data")
            return
        }
        
        print("Preparing flow action")
        
        let destination = segue.destination
        prepareDestination(targetController: destination, data: data)
    }
    
    func prepareDestination(targetController: UIViewController, data: FlowPrepareData){
        let vm = data.vmFactory(data.arguments)
        let flowCoordinator = data.flowCoordinatorFactory?(data.arguments) ?? self
        if let baseVC = targetController as? BaseController{
            baseVC.viewModel = vm
            baseVC.flowCoordinator = flowCoordinator
        }
        data.setupVC?(vm, flowCoordinator, targetController)
    }
}

struct FlowPrepareData{
    let vmFactory: VMFactory
    let arguments: Any?
    let flowCoordinatorFactory: FlowCoordinatorFactory?
    let setupVC: VCSetupHandler?
    
    init(vmFactory: @escaping VMFactory, data: Any? = nil, flowCoordinatorFactory: FlowCoordinatorFactory? = nil, setupVC: VCSetupHandler? = nil) {
        self.vmFactory = vmFactory
        self.arguments = data
        self.flowCoordinatorFactory = flowCoordinatorFactory
        self.setupVC = setupVC
    }
}

typealias VCSetupHandler = (_ vm: Any?, _ flowCoordinator: Any?, _ viewController: UIViewController)->Void
typealias FlowCoordinatorFactory = (Any?)->Any?
typealias VMFactory = (Any?)->Any?
