//
//  SignUpViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: BaseViewController<SignUpViewModel, InitialFlowCoordinator>{
    @IBOutlet weak var userNameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var confirmPasswordView: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let keyboardHeightHandler = KeyboardHeightHandler()

    lazy var userNameValidator = InputValidator()
    lazy var passwordValidator = InputValidator()
    lazy var confirmPasswordValidator = InputValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.hideLoading()
        
        observeProperty(getVM().signUpState){ (property) in
            guard let property = property else { return }

            switch property {
                case .loading:
                    self.showLoading()
                case .error(let error):
                    self.hideLoading()
                    self.handleError(error)
                case .success:
                    self.hideLoading()
                    self.dismiss(animated: true, completion: nil)
            }
        }
        
        observeDependent(userNameValidator.validityObservable, passwordValidator.validityObservable){ validUser, validPassword in
            self.updateLoginButtonEnabled(valid: validUser ?? false && validPassword ?? false)
        }
        
        keyboardHeightHandler.startHandling(controller: self, textFields: [userNameView, passwordView])
        userNameValidator.startValidating(textField: userNameView)
        passwordValidator.startValidating(textField: passwordView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHeightHandler.stopHandling()
    }
    
    deinit {
        userNameValidator.stopValidating()
        passwordValidator.stopValidating()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        guard userNameValidator.isValid() && passwordValidator.isValid() && confirmPasswordValidator.isValid(),
            let userName = userNameView.text, let password = passwordView.text else { return }
        getVM().signUp(username: userName, password: password)
    }
    
    override func getLoadingView() -> UIView?{
        return activityIndicator
    }
    
    func setupViews(){
        loginButton.setTitleColor(.black, for: .selected)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .disabled)
        
        passwordView.delegate = self
        userNameView.delegate = self
    }
    
    func updateLoginButtonEnabled(valid: Bool){
        if valid {
            loginButton.backgroundColor = UIColor(named: "AccentColor")
            loginButton.isEnabled = true
        }else{
            loginButton.backgroundColor = .lightGray
            loginButton.isEnabled = false
        }
    }
    
    override func enableAfterLoading(){
        loginButton.isEnabled = true
        passwordView.isEnabled = true
        userNameView.isEnabled = true
        confirmPasswordView.isEnabled = true
    }
    
    override func disableWhileLoading(){
        loginButton.isEnabled = false
        passwordView.isEnabled = false
        userNameView.isEnabled = false
        confirmPasswordView.isEnabled = false
    }
}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
