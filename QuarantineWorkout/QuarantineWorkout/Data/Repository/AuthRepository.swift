//
//  AuthRepository.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 14/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import Firebase

class AuthRepository: Repository{
    func login(_ input: LoginInput, completion: @escaping AsyncCompletion<LoginRepoResult>){
        Auth.auth().signIn(withEmail: input.username, password: input.password){ (result, error) in
            if let error = error{
                completion(.error(error))
            }else{
                completion(.success(LoginRepoResult()))
            }
        }
    }
    
    
    struct LoginRepoResult{
        
    }
}
