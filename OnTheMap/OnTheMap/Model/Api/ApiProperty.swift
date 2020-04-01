//
//  ApiProperty.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ApiProperty<T: Decodable>{
    let id: String?
    
    typealias ChangeCallback = (ApiProperty<T>)->Void
    typealias DisposeCallback = (String)->Void
    
    var state : State
    var request : ApiRequest<T>?
    var value : T?
    var error : Error?
    
    var callbacks : [String: (ApiProperty<T>)->Void]
    private var requestTask : URLSessionTask? = nil
    
    enum State: String{
        case idle, loading, error, success
    }
    
    init(withId id: String? = nil, andRequest request: ApiRequest<T>? = nil){
        self.request = request
        state = .idle
        value = nil
        error = nil
        callbacks = [:]
        self.id = id
    }
    
    /* Load data from request (or use previous request for nil)  */
    func load(request: ApiRequest<T>? = nil){
        guard let req = request ?? self.request else { return }
        self.request = req
        
        guard request != nil || state != .loading else { return }
        state = .loading
        notifyChange()
        cancelPreviousRequest()
        
        requestTask = req.execute(callback: { (data, error) in
            if(error != nil){
                print("Property error")
                self.state = .error
                self.error = error
            }else{
                print("Property success")
                self.state = .success
                self.value = data
            }
            self.notifyChange()
        })
    }
    
    func cancelPreviousRequest(){
        requestTask?.cancel()
        requestTask = nil
    }
    
    func addCallback(identifier: String, callback: @escaping ChangeCallback) -> (String)->Void{
        callbacks[identifier] = callback
        
        if(state == .error || state == .idle){
            load()
        }else{
            callback(self)
        }
        
        return removeCallback(identifier:)
    }
    
    func removeCallback(identifier: String){
        callbacks.removeValue(forKey: identifier)
    }
    
    private func notifyChange(){
        printProperty()
        callbacks.values.forEach { (callback: @escaping (ApiProperty<T>) -> Void) in
            print("Callback notify")
            callback(self)
        }
    }
    
    public func printProperty(){
        print("Property - \(id ?? "") - state: \(state)")
    }
}
