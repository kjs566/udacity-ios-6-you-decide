//
//  PlaceLocationViewController.swift
//  VirtualTourist
//
//  Created by Jan Skála on 06/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PlaceLocationViewController : PropertyObserverController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pinView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var address: String? = nil
    var url: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    var userProfile: UserProfileResponseBody? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lat = latitude, let lon = longitude{
            mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), animated: false)
        }
        if #available(iOS 13.0, *) {
            mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100), animated: true)
        }
        observeProperty(UdacityApi.shared.userProfileProperty) { (userResult) in
            guard let userResult = userResult else { return }
            
            self.resetStates()
            switch userResult.state{
            case .error: self.handleError(userResult.error)
            case .success: self.setPrepared(userProfile: userResult.value!)
            case .loading: self.setLoading()
            case .idle: break
            }
        }
        observeProperty(ParseApi.shared.postLocationProperty) { (postResult) in
            guard let postResult = postResult else { return }

            self.resetStates()
            switch postResult.state{
            case .error: self.handleError(postResult.error)
            case .success:
                ParseApi.shared.studentLocationsProperty.load()
                self.navigationController?.popToRootViewController(animated: true)
            case .loading: self.setLoading()
            case .idle: break
            }
        }
    }
    
    func resetStates(){
        self.saveButton.isEnabled = true
        self.pinView.isHidden = false
        self.loadingIndicator.isHidden = true
    }
    
    func setPrepared(userProfile: UserProfileResponseBody){
        self.saveButton.isEnabled = true
        self.userProfile = userProfile
    }
    
    func setLoading(){
        self.saveButton.isEnabled = false
        self.pinView.isHidden = true
        self.loadingIndicator.isHidden = false
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let firstName = userProfile?.firstName, let lastName = userProfile?.lastName, let address = self.address, let url = self.url else { return }
        
        let lat = mapView.centerCoordinate.latitude
        let lon = mapView.centerCoordinate.longitude
        ParseApi.shared.placeLocation(firstName: firstName, lastName: lastName, address: address, url: url, lat: lat, lon: lon)
    }
}
