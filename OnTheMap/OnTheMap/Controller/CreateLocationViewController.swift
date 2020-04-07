//
//  CreateLocationViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class CreateLocationViewController : PropertyObserverController{
    
    @IBOutlet weak var addressView: UITextField!
    @IBOutlet weak var urlView: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let addressValidator = InputValidator()
    let urlValidator = InputValidator()
    
    let keyboardHandler = KeyboardHeightHandler()
    let geocodeLocationProperty = GeocodeLocationPropety()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.isHidden = true
        keyboardHandler.startHandling(controller: self, textFields: [addressView, urlView])
        addressValidator.startValidating(textField: addressView)
        urlValidator.startValidating(textField: urlView)
        
        observeDependent(urlValidator.validityObservable, addressValidator.validityObservable) { (urlValid, addressValid) in
            self.updateButtonEnabled(valid: urlValid != nil && urlValid! && addressValid != nil && addressValid!)
        }
        
        observeProperty(geocodeLocationProperty) { (locationResult) in
            guard let locationResult = locationResult else { return }
            
            self.loadingIndicator.isHidden = true
            self.updateButtonEnabled(valid: true)
            self.findLocationButton.isEnabled = true
            self.addressView.isEnabled = true
            self.urlView.isEnabled = true

            
            switch locationResult.state {
            case .loading:
                self.loadingIndicator.isHidden = false
                self.updateButtonEnabled(valid: false)
                self.addressView.isEnabled = false
                self.urlView.isEnabled = false
            case .error:
                self.showError("Location not found, please try again.")
            case .success(let locations):
                let withCoordinate = locations?.filter({ (placemark) -> Bool in
                    placemark.location?.coordinate != nil
                })
                if withCoordinate != nil && !withCoordinate!.isEmpty{
                    self.performSegue(withIdentifier: "placeLocationSegue", sender: withCoordinate!.first!)
                }else{
                    self.showError("Location not found, please specify it more accurately.")
                }
            }
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
        if segue.destination is PlaceLocationViewController {
            let placemark = sender as! CLPlacemark
            let vc = segue.destination as! PlaceLocationViewController
            vc.address = addressView.text
            vc.url = urlView.text
            vc.latitude = placemark.location!.coordinate.latitude
            vc.longitude = placemark.location!.coordinate.longitude
        }
    }
    @IBAction func cancelClicked(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func updateButtonEnabled(valid: Bool){
        if valid {
            findLocationButton.backgroundColor = UIColor(named: "UdacityColor")
            findLocationButton.isEnabled = true
        }else{
            findLocationButton.backgroundColor = .lightGray
            findLocationButton.isEnabled = false
        }
    }
    
    @IBAction func findLocationClicked(_ sender: Any) {
        guard let address = addressView.text else { return }
        
        findLocationButton.isEnabled = false
        addressView.isEnabled = false
        urlView.isEnabled = false
        
        geocodeLocationProperty.load(address: address)
    }
}
