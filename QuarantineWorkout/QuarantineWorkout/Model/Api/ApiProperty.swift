//
//  ApiProperty.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ApiProperty<T : Decodable> : ObservableProperty<ApiResult<T>>{
    var request : ApiRequest<T>?
    
    private var requestTask : URLSessionTask? = nil
    
    init(withId id: String = "", andRequest request: ApiRequest<T>? = nil){
        super.init(withId: id)
        self.request = request
        callbacks = [:]
    }
    
    /* Load data from request (or use previous request for nil)  */
    func load(request newRequest: ApiRequest<T>? = nil){
        guard let req = newRequest ?? self.request else { return }
        self.request = req
        
        //guard request != nil || !state.isLoading() else { return }
        cancelPreviousRequest()
        setValue(.loading)
        
        requestTask = req.execute(callback: { (data, error) in
            if error != nil {
                print("Property error")
                self.setValue(.error(error))
            }else{
                print("Property success")
                self.setValue(.success(data))
            }
        })
    }
    
    func cancelPreviousRequest(){
        requestTask?.cancel()
        requestTask = nil
    }
    
    override func afterCallbackAdd() {
        if value == nil || value!.isError(){
            load()
        }
    }
    
    override func afterCallbackRemove() {
        if callbacks.isEmpty {
            cancelPreviousRequest()
        }
    }
}
