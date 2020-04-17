//
//  UseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 14/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//
import Foundation

protocol BgUseCase: UseCase{
    func executeBackground(input: Input, completion: @escaping RepositoryCompletion)
}

extension BgUseCase{
    func execute(input: Input, completion: @escaping ViewModelCompletion){
        DispatchQueue.global(qos: .background).async{
            self.executeBackground(input: input, completion: {
                (repoResult: AsyncCallback<RepositoryResult>) in
                let result: AsyncCallback<Result>
                switch repoResult{
                case .error(let error):
                    result = .error(self.mapError(error))
                case .success(let value):
                    result = .success(self.mapResult(value))
                }
                    
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
}
