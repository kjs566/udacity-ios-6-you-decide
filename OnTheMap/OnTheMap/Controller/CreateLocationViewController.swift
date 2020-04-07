//
//  CreateLocationViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class CreateLocationViewController : PropertyObserverController{
    
    @IBOutlet weak var addressView: UITextField!
    @IBOutlet weak var urlView: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    let addressValidator = InputValidator()
    let urlValidator = InputValidator()
    
    let keyboardHandler = KeyboardHeightHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler.startHandling(controller: self, textFields: [addressView, urlView])
        addressValidator.startValidating(textField: addressView)
        urlValidator.startValidating(textField: urlView)
        
        observeDependent(urlValidator.validityObservable, addressValidator.validityObservable) { (urlValid, addressValid) in
            self.updateButtonEnabled(valid: urlValid != nil && urlValid! && addressValid != nil && addressValid!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    deinit {
        addressValidator.stopValidating()
        urlValidator.stopValidating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is PlaceLocationViewController){
            let vc = segue.destination as! PlaceLocationViewController
            vc.address = addressView.text
            vc.url = urlView.text
        }
    }
    @IBAction func cancelClicked(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func updateButtonEnabled(valid: Bool){
        if(valid){
            findLocationButton.backgroundColor = UIColor(named: "UdacityColor")
            findLocationButton.isEnabled = true
        }else{
            findLocationButton.backgroundColor = .lightGray
            findLocationButton.isEnabled = false
        }
    }
    
}
