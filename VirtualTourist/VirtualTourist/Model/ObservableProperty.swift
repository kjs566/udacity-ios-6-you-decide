//
//  ObservableProperty.swift
//  VirtualTourist
//
//  Created by Jan Skála on 06/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ObservableProperty<T>{
    var id: String?
    
    typealias ChangeCallback = (T?)->Void
    typealias DisposeCallback = (String)->Void
    
    var value: T? = nil
    var callbacks : [String: ChangeCallback] = [:]
    
    init(withId id: String? = nil) {
        self.id = id
    }
    
    open func setValue(_ value: T?, notify: Bool = true){
        self.value = value
        if notify {
            notifyChange()
        }
    }
    
    open func getValue() -> T?{
        return value
    }
    
    open func beforeCallbackAdd(){
        
    }
    
    open func afterCallbackRemove(){
        
    }
    
    open func addCallback(identifier: String, callback: @escaping ChangeCallback) -> (String)->Void{
        callbacks[identifier] = callback
        
        beforeCallbackAdd()
        callback(value)
        
        return removeCallback(identifier:)
    }
    
    func removeCallback(identifier: String){
        callbacks.removeValue(forKey: identifier)
        afterCallbackRemove()
    }
    
    func clearValue(){
        setValue(nil, notify: false)
    }
    
    private func notifyChange(){
        callbacks.values.forEach { (callback: @escaping ChangeCallback) in
            print("Callback notify")
            callback(value)
        }
    }
}
