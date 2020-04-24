//
//  AuthRepository.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 14/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import Firebase

class AuthRepository: BaseRepository{
    func signUp(_ input: SignUpInput, completion: @escaping AsyncCompletion<SignUpRepoResult>){
        Auth.auth().createUser(withEmail: input.username, password: input.password) { (result, error) in
            self.handleCompletionAsync(result: result, error: error, mapper: { (_) in
                return SignUpRepoResult()
            }, completion: completion)
        }
    }
    
    func login(_ input: LoginInput, completion: @escaping AsyncCompletion<LoginRepoResult>){
        Auth.auth().signIn(withEmail: input.username, password: input.password){ (result, error) in
            self.handleCompletionAsync(result: result, error: error, mapper: { (_) in
                return LoginRepoResult()
            }, completion: completion)
        }
    }
    
    func logout(completion: @escaping AsyncCompletion<LogoutRepoResult>){
        do{
            try Auth.auth().signOut()
            completion(.success(LogoutRepoResult()))
        }catch{
            completion(.error(error))
        }
    }
    
    func getUserEmail() -> String?{
        return Auth.auth().currentUser?.email
    }
    
    
    struct LoginRepoResult{}
    struct SignUpRepoResult{}
    struct LogoutRepoResult{}
}
