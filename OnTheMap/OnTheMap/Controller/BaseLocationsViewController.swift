//
//  BasePinsListViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

open class BaseLocationsViewController: PropertyObserverController {
    var locationsLoading: Bool = true
    var locationsError: Bool = false
    var locations = [StudentLocationsResponseBody.StudentLocation]()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        observeProperty(ParseApi.shared.studentLocationsProperty) { (property) in
            guard let property = property else { return }
            
            self.locationsLoading = false
            self.locations = []
            self.locationsError = false
            
            switch property.state {
                case .loading:
                    self.locationsLoading = true
                case .error:
                    self.locationsError = true
                    self.handleError(property.error)
                case .success:
                    if let locations = property.value?.results {
                        self.locations = locations
                    }
                default: break
            }
            self.locationsUpdated()
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getData() -> [StudentLocationsResponseBody.StudentLocation] {
        return locations
    }
    
    open func getItemsCount() -> Int{
        return getData().count
    }
    
    func getItemIndex(indexPath: IndexPath) -> Int{
        return indexPath.item
    }
    
    func getItem(atIndexPath: IndexPath) -> StudentLocationsResponseBody.StudentLocation?{
        let data = getData()
        let index = getItemIndex(indexPath: atIndexPath)
        if(data.count > index){
            return data[index]
        }else{
            return nil
        }
    }
    
    func showLocation(urlString: String?){
        guard var url = urlString else { return }
        if(!url.starts(with: "http")){
            url = "https://\(url)"
        }
        let app = UIApplication.shared
        if let openUrl = URL(string: url) {
            app.open(openUrl, options: [:], completionHandler: nil)
        }
    }
    
    func showLocation(_ location: StudentLocationsResponseBody.StudentLocation){
        showLocation(urlString: location.mediaURL)
    }
    
    func createLocation(){
        performSegue(withIdentifier: "createLocationSegue", sender: nil)
    }
    
    func reloadLocations(){
        ParseApi.shared.studentLocationsProperty.load()
    }
    
    func logout(){
        UdacityApi.shared.deleteSession()
        tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    open func locationsUpdated(){}
}
