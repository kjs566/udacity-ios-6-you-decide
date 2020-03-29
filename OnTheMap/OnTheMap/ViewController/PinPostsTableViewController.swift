//
//  PinPostsTableViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class PinPostsTableViewController: BasePinsViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItemsCount() + 1 // Always show add in the list as last item
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = getItem(atIndexPath: indexPath){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PinPostTableCell", for: indexPath) as! PinPostTableViewCell
            //cell.postImage?.image = item.memedImage
            cell.postText?.text = "TEST"//concatTexts(texts: item.texts)
            return cell
        }else{
            return tableView.dequeueReusableCell(withIdentifier: "AddTableCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let item = getItem(atIndexPath: indexPath){
            showPinPost(item)
        }else{
            createPinPost()
        }
    }
}
