//
//  ApiResult.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 06/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

enum AsyncCallback<T>{
    typealias SuccessHandler = (T?)->Void
    typealias LoadingHandler = ()->Void
    typealias ErrorHandler = (Error?)->Void
    
    case success(_ value: T?)
    case error(_ error: Error?)
    
    func onSuccess(_ completionHandler: SuccessHandler?){
        if case .success(let value) = self {
            completionHandler?(value)
        }
    }
    
    func onError(_ completionHandler: ErrorHandler?){
        if case .error(let error) = self{
            completionHandler?(error)
        }
    }
    
    func handle(success: SuccessHandler? = nil, error: ErrorHandler? = nil){
        onSuccess(success)
        onError(error)
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
    
    func toResult() -> AsyncResult<T>{
        switch self {
        case .success(let value):
            return .success(value)
        case .error(let error):
            return .error(error)
        }
    }
}
