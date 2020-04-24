//
//  GetUserEmailUseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 24/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class GetUserEmailUseCase: SyncUseCase{
    typealias Input = None
    typealias Result = String
    typealias RepositoryResult = String?
    
    let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func executeSync(input: Input) -> RepositoryResult {
        return authRepository.getUserEmail()
    }
}
