//
//  PropertyObserver.swift
//  OnTheMap
//
//  Created by Jan Skála on 01/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class PropertyObserver{
    let id = IdGenerator.shared.generateUniqueId()
    private var callbackDisposes = [ObservableProperty.DisposeCallback]()

    func observeProperty<T>(_ property: ApiProperty<T>,_ callback: @escaping ApiProperty<T>.ChangeCallback){
        callbackDisposes.append(property.addCallback(identifier: id, callback: callback))
    }
    
    func observeProperty<T>(_ property: ObservableProperty<T>, _ callback: @escaping ObservableProperty<T>.ChangeCallback){
        callbackDisposes.append(property.addCallback(identifier: id, callback: callback))
    }
    
    func observeDependent<T, R>(_ property1: ObservableProperty<T>, _ property2: ObservableProperty<R>, callback: @escaping ((T?, R?)->Void?)){
        var value1: T? = nil
        var value2: R? = nil
        
        observeProperty(property1){ val1 in
            value1 = val1
            callback(value1, value2)
        }
        observeProperty(property2){ val2 in
            value2 = val2
            callback(value1, value2)
        }
    }
    
    func dispose(){
        for dispose in callbackDisposes{
            dispose(id)
        }
        callbackDisposes = []
    }
}
