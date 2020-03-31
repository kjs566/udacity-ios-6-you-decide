//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    override func viewDidLoad() {
        let app = (UIApplication.shared.delegate as! AppDelegate)
        print("Controler")
        app.parseApiClient.studentLocationsRequest.execute { (response, error) in
            print("REPSONSE")
            print(response != nil ? "not nil" : "nil")
            print("ERROR")
            print(error != nil ? "not nil" : "nil")
        }
        
        
        app.parseApiClient.studentLocationsProperty.addCallback(identifier: "TEST") { (property) in
            print("PROPERTY CHANGE")
            print(property)
        }
    }
}
