//
//  PinPostsTableViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class LocationsTableViewController: BaseLocationsViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = tabBarController {
            self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarController.tabBar.frame.height, right: 0.0);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func getItemsCount() -> Int {
        var count = super.getItemsCount()
        if locationsLoading{
            count += 1 // Loading item
        }
        count += 1 // Add location item
        return count
    }
    
    override func locationsUpdated(){
        tableView.reloadData()
    }
    
    @IBAction func reloadClicked(_ sender: Any) {
        reloadLocations()
    }
    @IBAction func addClicked(_ sender: Any) {
        createLocation()
    }
    @IBAction func logoutClicked(_ sender: Any) {
        logout()
    }
    
}

// MARK: - UITableViewDelegate
extension LocationsTableViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let actualCount = super.getItemsCount()
        let index = getItemIndex(indexPath: indexPath)
        
        var cellIdentifier : String?
        var interactionEnabled = true
        
        if index == actualCount && locationsLoading{
            cellIdentifier = "LoadingTableCell"
            interactionEnabled = false
        }else if index > actualCount || (index == actualCount && !locationsLoading){
            cellIdentifier = "AddTableCell"
        }else{
            cellIdentifier = "LocationTableCell"
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier!, for: indexPath)
        cell.isUserInteractionEnabled = interactionEnabled
        if let item = getItem(atIndexPath: indexPath){
            let locationCell = cell as! LocationTableViewCell
            locationCell.locationText.text = "\(item.firstName ?? "") \(item.lastName ?? "")"
            locationCell.locationDescription.text = "\(item.mediaURL ?? "")"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let item = getItem(atIndexPath: indexPath){
            showLocation(item)
        }else{
            createLocation()
        }
    }
}
