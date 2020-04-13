//
//  ApiResult.swift
//  VirtualTourist
//
//  Created by Jan Skála on 06/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

enum AsyncResult<T>{
    typealias SuccessHandler = (T?)->Void
    typealias LoadingHandler = ()->Void
    typealias ErrorHandler = (Error?)->Void
    
    case success(_ value: T?)
    case loading
    case error(_ error: Error?)
    
    func onSuccess(_ completionHandler: SuccessHandler?){
        if case .success(let value) = self {
            completionHandler?(value)
        }
    }
    
    func onLoading(_ completionHandler: LoadingHandler?){
        if case .loading = self {
            completionHandler?()
        }
    }
    
    func onError(_ completionHandler: ErrorHandler?){
        if case .error(let error) = self{
            completionHandler?(error)
        }
    }
    
    func handle(success: SuccessHandler? = nil, error: ErrorHandler? = nil, loading: LoadingHandler? = nil){
        onSuccess(success)
        onError(error)
        onLoading(loading)
    }
    
    func isError() -> Bool{
        if case .error = self {
            return true
        }
        return false
    }

    func isSuccess() -> Bool{
        if case .success = self {
            return true
        }
        return false
    }
    
    func isLoading() -> Bool{
        if case .loading = self {
            return true
        }
        return false
    }
}
