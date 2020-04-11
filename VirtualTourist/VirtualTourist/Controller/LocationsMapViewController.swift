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
    var annotationPins = [MKPointAnnotation:Pin]()
    let pinsProperty = CoreDataCollectionProperty<Pin>()
    
    override func viewDidLoad() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addPin(gestureRecognizer:)))
        longPressRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressRecognizer)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "mapLon") != nil{
            // Restore last position
            let mapLon = UserDefaults.standard.double(forKey: "mapLon")
            let mapLat = UserDefaults.standard.double(forKey: "mapLat")
            mapView.setCenter(CLLocationCoordinate2D(latitude: mapLat, longitude: mapLon), animated: false)
        }
        
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
            
            DataController.shared.createAndSave(initializer: { (pin: Pin) in
                pin.lat = coordinates.latitude
                pin.lon = coordinates.longitude
                pin.isNew = true
            }, errorHandler: { (error) in
                self.handleError(error)
            })
        }
    }
    
    func updateAnnotations(_ pins: Array<Pin>?){
        guard let pins = pins else { return }
        
        mapView.removeAnnotations(annotations)
        annotations = []
        annotationPins = [:]
        for pin in pins{
           // guard let lat = pin.lat, let long = pin.lon else { return }

            let coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            annotations.append(annotation)
            annotationPins[annotation] = pin
        }
        mapView.addAnnotations(annotations)
    }
    
    func showLocation(annotation: MKAnnotation?){
        guard let annotation = annotation as? MKPointAnnotation, let pin = annotationPins[annotation] else { return }
        
        performSegue(withIdentifier: "pinDetailSegue", sender: pin)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? PinDetailViewController, let pin = sender as! Pin? else { return }
        vc.pin = pin
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

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        showLocation(annotation: view.annotation)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Save current position
        let mapLat = mapView.centerCoordinate.latitude
        let mapLon = mapView.centerCoordinate.longitude
        
        UserDefaults.standard.set(mapLon, forKey: "mapLon")
        UserDefaults.standard.set(mapLat, forKey: "mapLat")
    }
}
