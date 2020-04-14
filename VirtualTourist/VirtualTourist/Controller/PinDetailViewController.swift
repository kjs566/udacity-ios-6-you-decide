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
import CoreData

class PinDetailViewController : PropertyObserverController{
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pin: Pin!
    var loadingPhotos = Set<String>()
    var dataSource: FetchedCollectionViewDataSource? = nil
    
    var photoCollectionDownloader: PhotoCollectionDownloader? = nil
    
    override func viewDidLoad() {
        showAnnotation()
        centerPin()
        
        photoCollectionDownloader = PhotoCollectionDownloader(pin: pin)
        observeProperty(photoCollectionDownloader!.state){ state in
            guard let state = state else { return }
            
            state.handle(success: { (_) in
                self.newCollectionButton.isEnabled = true
                self.loadingIndicator.isHidden = true
            }, error: { (error) in
                self.newCollectionButton.isEnabled = true
                self.handleError(error)
                self.loadingIndicator.isHidden = true
            }) {
                self.newCollectionButton.isEnabled = false
                self.loadingIndicator.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin.objectID)
        dataSource = FetchedCollectionViewDataSource(collectionView: collectionView, sortDescriptors: [NSSortDescriptor(key: "photoId", ascending: true)], fetchRequest: fetchRequest as! NSFetchRequest<NSManagedObject>)
        dataSource?.delegate = self
        
        dataSource?.fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dataSource = nil
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
        photoCollectionDownloader?.loadNextPage()
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
}

// MARK: - FetchedTableViewDataSourceDelegate
extension PinDetailViewController: FetchedCollectionViewDataSourceDelegate{
    func collectionViewCellIdentifier(atIndex: IndexPath, forObject: NSManagedObject) -> String {
        let photo = forObject as! Photo
        
        if photo.error{
            return "loadingFailedCollectionCell"
        } else if photo.isNew {
            return "loadingCollectionCell"
        } else {
            return "imageCollectionCell"
        }
    }
    
    func collectionViewCellConfigure(cell: UICollectionViewCell, atIndex: IndexPath, forObject: NSManagedObject) {
        let photo = forObject as! Photo
        
        if !photo.isNew && !photo.error{
            let imageCell = cell as! ImageCollectionViewCell
            if let data = photo.image{
                imageCell.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func collectionViewCellDidSelect(atIndex: IndexPath, forObject: NSManagedObject){
        let photo = forObject as! Photo
        
        DataController.shared.remove(photo, errorHandler: {
            error in
            self.handleError(error)
        })
    }
}
