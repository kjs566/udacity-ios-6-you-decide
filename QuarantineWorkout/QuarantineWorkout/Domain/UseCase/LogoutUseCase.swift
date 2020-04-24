//
//  LogoutUseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 14/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class LogoutUseCase: BgUseCase{
    typealias Input = None
    typealias Result = LogoutResult
    typealias RepositoryResult = AuthRepository.LogoutRepoResult
    
    let authRepo: AuthRepository
    
    init(authRepo: AuthRepository){
        self.authRepo = authRepo
    }
    
    func executeBackground(input: None, completion: @escaping (AsyncCallback<AuthRepository.LogoutRepoResult>) -> Void) {
        self.authRepo.logout(completion: completion)
    }
    
    func mapResult(_ repositoryResult: AuthRepository.LogoutRepoResult?) -> LogoutResult? {
        return LogoutResult()
    }
}

struct LogoutResult{}
