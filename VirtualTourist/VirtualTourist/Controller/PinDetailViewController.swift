//
//  PinDetailViewController.swift
//  VirtualTourist
//
//  Created by Jan Skála on 11/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinDetailViewController : PropertyObserverController{
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pin: Pin!
    
    override func viewDidLoad() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addPin(gestureRecognizer:)))
        longPressRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressRecognizer)
        
        showAnnotation()
        centerPin()
        
        if pin.isNew{
            startApiLoading(page: pin.flickerPage)
        }
        /*observeProperty(pinsProperty){ result in
            self.loadingIndicator.isHidden = true
            result?.handle(success: { (pins) in
                self.updateAnnotations(pins)
            }, error: { (error) in
                self.handleError(error)
            }, loading: {
                self.loadingIndicator.isHidden = false
            })
        }*/
    }
    
    func startApiLoading(page: Int32){
        let photosListLoadingProperty = FlickerApi.shared.getSearchPhotosProperty(lon: pin.lon, lat: pin.lat, page: Int(page))
        
        observeProperty(photosListLoadingProperty) { (result) in
            self.loadingIndicator.isHidden = true
            guard let result = result else { return }
            result.handle(success: { (response) in
                self.savePhotosCollection(response)
            }, error: { error in
                self.handleError(error)
            }, loading: {
                self.loadingIndicator.isHidden = false
            })
        }
    }
    
    func savePhotosCollection(_ response: PhotosResponse?){
        
    }
    
    func loadNextPage(){
        let page = pin.flickerPage + 1
        DataController.shared.updateBackground(id: pin.objectID, updater: { (pin: Pin) in
            pin.flickerPage = page
            pin.isNew = true
        }, errorHandler:  nil)
        startApiLoading(page: page)
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
            }, errorHandler:  { (error) in
                self.handleError(error)
            })
        }
    }
    
    func showAnnotation(){
        let coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    func centerPin(){
        mapView.setCenter(CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon), animated: false)
    }
    
    @IBAction func newCollectionClicked(_ sender: Any) {
    }
}

// MARK: - MKMapViewDelegate
extension PinDetailViewController: MKMapViewDelegate{
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
            
        }
    }
}
