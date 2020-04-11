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
    let pinsProperty = CoreDataCollectionProperty<Pin>()
    
    override func viewDidLoad() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addPin(gestureRecognizer:)))
        longPressRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressRecognizer)
        
        observeProperty(pinsProperty){ result in
            self.loadingIndicator.isHidden = true
            result?.handle(success: { (pins) in
                self.updateAnnotations(pins)
            }, error: { (error) in
                self.handleError(error)
            }, loading: {
                self.loadingIndicator.isHidden = false
            })
        }
    }
    
    @objc
    func addPin(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            //let annotation = MKPointAnnotation()
            //annotation.coordinate = coordinates
            
            DataController.shared.createAndSave(initializer: { (pin: Pin) in
                pin.lat = coordinates.latitude
                pin.lon = coordinates.longitude
            }) { (error) in
                handleError(error)
            }
        }
    }
    
    func updateAnnotations(_ pins: Array<Pin>?){
        guard let pins = pins else { return }
        
        mapView.removeAnnotations(annotations)
        annotations = []
        for pin in pins{
           // guard let lat = pin.lat, let long = pin.lon else { return }

            let coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func showLocation(annotation: MKAnnotation?){
        guard let annotation = annotation else { return }
        // TODO
    }
}

// MARK: - MKMapViewDelegate
extension LocationsMapViewController: MKMapViewDelegate{
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
