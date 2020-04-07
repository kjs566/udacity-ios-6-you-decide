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
    var pinsLoading: Bool = true
    var pinsError: Bool = false
    var pins = [StudentLocationsResponseBody.StudentLocation]()
    
    open override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        observeProperty(ParseApi.shared.studentLocationsProperty) { (property) in
            self.pinsLoading = false
            self.pins = []
            self.pinsError = false
            
            switch property.state {
            case .loading:
                self.pinsLoading = true
            case .error:
                self.pinsError = true
            case .success:
                if let locations = property.value?.results {
                    self.pins = locations
                }
            default: break
        }
    }
    
    func getAppDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func getData() -> [PinPost] {
        return getAppDelegate().sharedData
    }
    
    func getItemsCount() -> Int{
        return getData().count
    }
    
    func getItemIndex(indexPath: IndexPath) -> Int{
        return indexPath.item
    }
    
    func getItem(atIndexPath: IndexPath) -> PinPost?{
        let data = getData()
        let index = getItemIndex(indexPath: atIndexPath)
        if(data.count > index){
            return data[index]
        }else{
            return nil
        }
    }
    
    func showPinPost(_ post: PinPost){
        performSegue(withIdentifier: "viewPostSegue", sender: post)
    }
    
    func createPinPost(){
        performSegue(withIdentifier: "createPostSegue", sender: nil)
    }
    
    open func pinsUpdated(){}
}
