//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : PropertyObserverController{
    override func viewDidLoad() {
        observeProperty(UdacityApiClient.shared.deleteSessionProperty){ (property) in
        }
        
        observeProperty(UdacityApiClient.shared.createSessionProperty){ (property) in
            if(property.state == .success){
                UdacityApiClient.shared.deleteSession()
            }
        }
    }
}
