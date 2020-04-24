//
//  SignUpUseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation


class SignUpUseCase: BgUseCase{
    typealias Input = SignUpInput
    typealias Result = SignUpResult
    typealias RepositoryResult = AuthRepository.SignUpRepoResult
    
    let authRepo: AuthRepository
    
    init(authRepo: AuthRepository){
        self.authRepo = authRepo
    }
    
    func executeBackground(input: SignUpInput, completion: @escaping (AsyncCallback<AuthRepository.SignUpRepoResult>) -> Void) {
        self.authRepo.signUp(input, completion: completion)
    }
    
    func mapResult(_ repositoryResult: AuthRepository.SignUpRepoResult?) -> SignUpResult? {
        return SignUpResult()
    }
    
    func mapError(_ error: Error?) -> Error? {
        if let description = error?.localizedDescription{
            return ExpectedError(message: description)
        }else{
            return error
        }
    }
    
}

struct SignUpInput{
    let username: String
    let password: String
}

struct SignUpResult{}
