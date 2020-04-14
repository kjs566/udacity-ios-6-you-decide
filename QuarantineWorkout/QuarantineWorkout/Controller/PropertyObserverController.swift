//
//  PropertyObserverController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 31/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

open class PropertyObserverController : BaseViewController{
    let propertyObserver = PropertyObserver()
    
    func observeProperty<T>(_ property: ObservableProperty<T>, _ callback: @escaping ObservableProperty<T>.ChangeCallback){
        propertyObserver.observeProperty(property, callback)
    }
    
    func observeDependent<T,R>(_ property1: ObservableProperty<T>, _ property2: ObservableProperty<R>, _ callback: @escaping (T?,R?)->Void){
        propertyObserver.observeDependent(property1, property2, callback: callback)
    }
    
    deinit {
        propertyObserver.dispose()
    }
    
}
