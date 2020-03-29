//
//  BasePinsListViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

open class BasePinsViewController: UIViewController{
    open override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
