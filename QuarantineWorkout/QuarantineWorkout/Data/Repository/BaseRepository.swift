//
//  BaseRepository.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 14/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

protocol BaseRepository{}

extension BaseRepository{
    func handleCompletionAsync<T, R>(result: T?, error: Error?, mapper: (T?)->R, completion: @escaping AsyncCompletion<R>){
        if error != nil{
            completion(.error(error))
        }else{
            completion(.success(mapper(result)))
        }
    }
}
