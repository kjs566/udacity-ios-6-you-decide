//
//  SignUpViewModel.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class SignUpViewModel: BaseViewModel{
    let signUpUC: SignUpUseCase
    
    init(signUpUseCase: SignUpUseCase) {
        self.signUpUC = signUpUseCase
    }
    
    let signUpState = ObservableProperty<AsyncResult<SignUpResult>>()
    
    func signUp(username: String, password: String){
        signUpState.setValue(.loading)
        signUpUC.execute(input: SignUpInput(username: username, password: password)) { callbackResult in
            self.signUpState.setValue(callbackResult.toResult())
        }
    }
}
