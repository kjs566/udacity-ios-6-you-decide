//
//  LoginUseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 14/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation


class LoginUseCase: BgUseCase{
    typealias Input = LoginInput
    typealias Result = LoginResult
    typealias RepositoryResult = AuthRepository.LoginRepoResult
    
    let authRepo: AuthRepository
    
    init(authRepo: AuthRepository){
        self.authRepo = authRepo
    }
    
    func executeBackground(input: LoginInput, completion: @escaping (AsyncCallback<AuthRepository.LoginRepoResult>) -> Void) {
        self.authRepo.login(input, completion: completion)
    }
    
    func mapResult(_ repositoryResult: AuthRepository.LoginRepoResult?) -> LoginResult? {
        return LoginResult()
    }
    
    
}

struct LoginInput{
    let username: String
    let password: String
}

struct LoginResult{}
