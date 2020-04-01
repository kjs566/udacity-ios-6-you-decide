//
//  PropertyObserverController.swift
//  OnTheMap
//
//  Created by Jan Skála on 31/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class PropertyObserverController : UIViewController{
    let propertyObserver = PropertyObserver()
    
    func observeProperty<T>(_ property: ApiProperty<T>,_ callback: @escaping ApiProperty<T>.ChangeCallback){
        propertyObserver.observeProperty(property, callback)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Is it necessary to clear callbacks? Is there another way to use Observer pattern without passing back clearing function and generating identifier?
        propertyObserver.dispose()
    }
    
}
