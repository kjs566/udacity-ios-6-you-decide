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
    private var callbackDisposes = [ApiProperty.DisposeCallback]()

    func observeProperty<T>(_ property: ApiProperty<T>,_ callback: @escaping ApiProperty<T>.ChangeCallback){
        callbackDisposes.append(property.addCallback(identifier: id, callback: callback))
    }
    
    func dispose(){
        for dispose in callbackDisposes{
            dispose(id)
        }
        callbackDisposes = []
    }
}
