//
//  ApiResult.swift
//  VirtualTourist
//
//  Created by Jan Skála on 06/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ApiResult<T: Decodable>{
    var state : State = .idle
    var value : T? = nil
    var error : Error? = nil
    
    enum State: String{
        case idle, loading, error, success
    }
    
    func setSuccess(value: T?){
        state = .success
        self.value = value
        self.error = nil
    }
    
    func setFailure(error: Error?){
        state = .error
        self.error = error
        self.value = nil
    }
    
    func setLoading(){
        state = .loading
        self.error = nil
        self.value = nil
    }
    
    func isLoading() -> Bool{
        return state == .loading
    }
    
    func isError() -> Bool{
        return state == .error
    }
    
    func isSuccess() -> Bool{
        return state == .success
    }
    
    func isIdle() -> Bool{
        return state == .idle
    }
}
