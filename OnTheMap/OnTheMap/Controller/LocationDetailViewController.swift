//
//  LocationDetailViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class LocationDetailViewController : UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        setupView()
    }
    
    func setArguments(location: StudentLocationsResponseBody.StudentLocation){

    }
    
    func setupView(){
        
    }
}
