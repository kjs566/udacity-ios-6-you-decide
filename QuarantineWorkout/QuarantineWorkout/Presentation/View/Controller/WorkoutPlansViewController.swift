//
//  PinPostsTableViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class WorkoutPlansViewController: BaseViewController<WorkoutPlansViewModel, WorkoutPlansFlowCoordinator>{
    
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
    
    @IBAction func showPlanDetailClicked(_ sender: Any) {
    }
    @IBAction func showPlanCreateClicked(_ sender: Any) {
    }
    
    func getItemsCount() -> Int {
        /*var count = super.getItemsCount()
        if locationsLoading{
            count += 1 // Loading item
        }
        count += 1 // Add location item
        return count*/
        return 1
    }
    
    func locationsUpdated(){
        tableView.reloadData()
    }
    
    @IBAction func reloadClicked(_ sender: Any) {
        //reloadLocations()
    }
    @IBAction func addClicked(_ sender: Any) {
        //createLocation()
    }
    @IBAction func logoutClicked(_ sender: Any) {
        //logout()
    }
    
}

// MARK: - UITableViewDelegate
extension WorkoutPlansViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AddTableCell"

        /*let actualCount = super.getItemsCount()
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
        return cell*/
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        /*if let item = getItem(atIndexPath: indexPath){
            showLocation(item)
        }else{*/
        getFlowCoordinator().showCreateNewPlan()
        //}
    }
}
