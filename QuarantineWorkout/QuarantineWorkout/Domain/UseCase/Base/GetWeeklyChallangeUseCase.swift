//
//  GetWeeklyChallangeUseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class GetWeeklyChallangeUseCase: UseCase{
    typealias Result = ApiProperty<WeeklyChallangeResponse>
    typealias RepositoryResult = ApiProperty<WeeklyChallangeResponse>
    typealias Input = None
    
    let apiRepo: ApiRepository
    
    init(apiRepo: ApiRepository) {
        self.apiRepo = apiRepo
    }
    
    func execute(input: None, completion: @escaping ViewModelCompletion) {
        completion(.success(apiRepo.weeklyChallangeProperty))
    }
}
