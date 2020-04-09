//
//  LocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationsMapViewController : PropertyObserverController{
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    func locationsUpdated() {
        /*
        //if locationsLoading {
            loadingIndicator.isHidden = false
        //}else if locationsError {
            loadingIndicator.isHidden = true
            // TODO
        //}else{
            loadingIndicator.isHidden = true
            //let locations = getData()
            
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
        //}
         */
    }
    
    func showLocation(annotation: MKAnnotation?){
        guard let annotation = annotation else { return }
        // TODO
    }
}

extension LocationsMapViewController: MKMapViewDelegate{
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
            showLocation(annotation: view.annotation)
        }
    }
}
