//
//  UseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 16/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

//
//  UseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 14/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

typealias AsyncCompletion<T> = (AsyncCallback<T>)->Void

import Foundation

protocol UseCase{
    associatedtype Input
    associatedtype Result
    associatedtype RepositoryResult
        
    func mapResult(_ repositoryResult: RepositoryResult?) -> Result?
    func mapError(_ error: Error?) -> Error?
}

extension UseCase{
    func mapResult(_ repositoryResult: RepositoryResult?) -> Result?{
        if (object_getClassName(RepositoryResult.self) == object_getClassName(Result.self)){
            return (repositoryResult as! Result)
        }else{
            fatalError("Result mapper has to be specified!")
        }
    }
    
    func mapError(_ error: Error?) -> Error?{
        return error
    }
}

protocol AsyncUseCase: UseCase{
    typealias RepositoryCompletion = AsyncCompletion<RepositoryResult>
    typealias ViewModelCompletion = AsyncCompletion<Result>
    
    func execute(input: Input, completion: @escaping ViewModelCompletion)
}

protocol SyncUseCase: UseCase{
    func executeSync(input: Input) -> RepositoryResult
}

extension SyncUseCase{
    func execute(input: Input) -> Result?{
        return mapResult((executeSync(input: input)))
    }
    
}
