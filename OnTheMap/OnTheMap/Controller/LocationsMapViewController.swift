//
//  LocationsMapViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationsMapViewController : BaseLocationsViewController, MKMapViewDelegate{
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    override func locationsUpdated() {
        if(locationsLoading){
            loadingIndicator.isHidden = false
        }else if(locationsError){
            loadingIndicator.isHidden = true
            // TODO
        }else{
            loadingIndicator.isHidden = true
            let locations = getData()
            
            self.mapView.removeAnnotations(annotations)
            for location in locations {
                guard let lat = location.latitude, let long = location.longitude else { return }

                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(location.firstName ?? "") \(location.lastName ?? "")"
                annotation.subtitle = location.mediaURL
                
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
        }
    }
    
    @IBAction func addClicked(_ sender: Any) {
        createLocation()
    }
    @IBAction func reloadClicked(_ sender: Any) {
        reloadLocations()
    }
    @IBAction func logoutClicked(_ sender: Any) {
        logout()
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            showLocation(urlString: view.annotation?.subtitle ?? nil)
        }
    }
    
}
