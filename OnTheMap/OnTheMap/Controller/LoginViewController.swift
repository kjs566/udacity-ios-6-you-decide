//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jan Skála on 30/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : PropertyObserverController{
    @IBOutlet weak var userNameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentlyEditingField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        observeProperty(UdacityApi.shared.createSessionProperty){ (property) in
            switch property.state {
            case .idle: break
            case .loading:
                self.showLoading()
                self.disableInput()
            case .error:
                self.handleError(error: property.error)
                self.hideLoading()
                self.enableInput()
            case .success:
                self.hideLoading()
                self.performSegue(withIdentifier: "showLocationSegue", sender: nil)
                self.enableInput()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableInput()
        hideLoading()
        
        subscribeKeyboardShowHide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeKeyboardShowHide()
    }
    
    func setupViews(){
        loginButton.setTitleColor(.black, for: .selected)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .disabled)
        passwordView.delegate = self
        userNameView.delegate = self
    }
    
    @IBAction func userNameChanged(_ sender: Any) {
        updateLoginButtonEnabled()
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        updateLoginButtonEnabled()
    }
    
    @IBAction func usernameEditingBegin(_ sender: Any) {
        setFieldInvalid(userNameView, false)
        currentlyEditingField = userNameView
    }
    
    @IBAction func passwordEditingBegin(_ sender: Any) {
        setFieldInvalid(passwordView, false)
        currentlyEditingField = passwordView
    }
    
    @IBAction func usernameEditingEnded(_ sender: Any) {
        if(!isUserNameValid()){
            setFieldInvalid(userNameView, true)
        }
    }
    
    @IBAction func passwordEditingEnded(_ sender: Any) {
        if(!isPasswordValid()){
            setFieldInvalid(passwordView, true)
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if(isValid()){
            login()
        }else{
            updateLoginButtonEnabled()
            setFieldInvalid(userNameView, !isUserNameValid())
            setFieldInvalid(passwordView, !isPasswordValid())
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func isUserNameValid() -> Bool {
        let userName = userNameView.text
        return userName != nil && !userName!.isEmpty
    }
    
    func isPasswordValid() -> Bool {
        let password = passwordView.text
        return password != nil && !password!.isEmpty
    }
    
    func isValid() -> Bool{
        return isUserNameValid() && isPasswordValid()
    }
    
    func updateLoginButtonEnabled(){
        if(isValid()){
            loginButton.backgroundColor = UIColor(named: "UdacityColor")
            loginButton.isEnabled = true
        }else{
            loginButton.backgroundColor = .lightGray
            loginButton.isEnabled = false
        }
    }
    
    func setFieldInvalid(_ field: UITextField, _ invalid: Bool){
        field.layer.borderColor = invalid ? UIColor(named: "InvalidColor")?.cgColor : UIColor.black.cgColor
        field.layer.borderWidth = 1.0
    }
    
    func login(){
        guard let username = userNameView.text, let password = passwordView.text else { return }
        UdacityApi.shared.createSession(username: username, password: password)
    }
    
    func enableInput(){
        updateLoginButtonEnabled()
        passwordView.isEnabled = true
        userNameView.isEnabled = true
    }
    
    func disableInput(){
        loginButton.isEnabled = false
        passwordView.isEnabled = false
        userNameView.isEnabled = false
    }
    
    func showLoading(){
        activityIndicator.isHidden = false
    }
    
    func hideLoading(){
        activityIndicator.isHidden = true
    }
    
    func handleError(error: Error?){
        if(error is ApiError){
            switch error as! ApiError{
            case .networkError:
                showError("Connection error.")
            case .errorResponse(let response):
                showError(response.error)
            default:
                showError("Unexpected error")
            }
        }else{
            showError() // Unexpected error
        }
    }
    
    func showError(_ message: String? = "Unknown error."){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {
            action in alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4){
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}


extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Keyboard state change
extension LoginViewController{
    func subscribeKeyboardShowHide(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeKeyboardShowHide(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification : Notification){
        let keyboardHeight = getKeyboardHeight(notification)
        
        let viewTopY = currentlyEditingField?.convert(CGPoint.zero, to: view).y ?? 0
        let viewBottomY = currentlyEditingField?.convert(CGPoint(x: 0, y: currentlyEditingField?.bounds.maxY ?? 0), to: view).y ?? 0
        
        let viewCenterY = viewTopY + viewBottomY / 2
        let totalHeight = view.bounds.height
        
        var y : CGFloat = -keyboardHeight + (totalHeight - viewCenterY) - 50 // Move view above keyboard (with  offset)
        if(y < -keyboardHeight){
            y = -keyboardHeight
        }
        view.frame.origin.y = y
    }
    
    @objc func keyboardWillHide(_ notification : Notification){
        resetFrameOrigin()
    }
    
    func resetFrameOrigin(){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification : Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
