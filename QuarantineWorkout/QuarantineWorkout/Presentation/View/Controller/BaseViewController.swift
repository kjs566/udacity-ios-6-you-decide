//
//  BaseViewController.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 07/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit

open class BaseTabController<VM: BaseViewModel, FC: BaseFlowCoordinator> : UITabBarController, BaseController{
    var loadingView: UIView? = nil
    var loadingTextView: UITextView? = nil
    
    var propertyObserver: PropertyObserver = PropertyObserver()
    
    var flowCoordinator: Any! = nil
    var viewModel: Any! = nil
    
    func getVM() -> VM{
        return viewModel as! VM
    }
    
    func getFlowCoordinator() -> FC{
        return flowCoordinator as! FC
    }
    
    open override func viewDidLoad() {
        if viewModel != nil && flowCoordinator != nil{
            print(String(describing: self) + " Set up successfull!")
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        (flowCoordinator as! BaseFlowCoordinator).prepareSegue(sourceController: self, segue: segue, sender: sender)
    }
    
    deinit {
        propertyObserver.dispose()
    }
}

open class BaseViewController<VM: BaseViewModel, FC: BaseFlowCoordinator>: UIViewController, BaseController{
    var loadingView: UIView? = nil
    var loadingTextView: UITextView? = nil
    
    var propertyObserver = PropertyObserver()
    
    var flowCoordinator: Any! = nil
    var viewModel: Any! = nil
    
    func getVM() -> VM{
        return viewModel as! VM
    }
    
    func getFlowCoordinator() -> FC{
        return flowCoordinator as! FC
    }
    
    func hideTabBar(){
        tabBarController?.tabBar.isHidden = true
    }
    
    func showTabBar(){
        tabBarController?.tabBar.isHidden = false
    }
    
    open override func viewDidLoad() {
        if viewModel != nil && flowCoordinator != nil{
            print(String(describing: self) + " Set up successfull!")
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        (flowCoordinator as! BaseFlowCoordinator).prepareSegue(sourceController: self, segue: segue, sender: sender)
    }
    
    deinit {
        propertyObserver.dispose()
    }
}

protocol BaseController : UIViewController{
    var loadingView: UIView? { set get }
    var loadingTextView: UITextView? { set get }
    
    var flowCoordinator: Any! { get set }
    var viewModel: Any! { get set }
    
    var propertyObserver: PropertyObserver { get set }
}

extension BaseController{
    func handleError(_ error: Error?){
        if error is ApiError {
            switch error as! ApiError{
            case .networkError:
                showError("Connection error.")
            default:
                showError("Unexpected error")
            }
        }else{
            showError()
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
    
    func showLoading(message: String? = "Loading..."){
        guard let w = UIApplication.shared.delegate?.window, let window = w else { return }
        if loadingView == nil{
            loadingView = UIView(frame: window.frame)
            guard let loadingView = loadingView else { return }
            
            loadingView.backgroundColor = .white
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 60, height: 60))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating()
            
            let constraints = [
                loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
            ]
            
            loadingTextView = UITextView()
            guard let loadingTextView = loadingTextView else { return }
            
            window.addSubview(loadingView)
            loadingView.addSubview(loadingIndicator)
            loadingView.addSubview(loadingTextView)
            
            loadingView.addConstraints(constraints)
            NSLayoutConstraint.activate(constraints)
            loadingView.updateConstraints()
        }
        
        loadingTextView?.text = message
    }
    
    func hideLoading(completion: (()->Void)? = nil){
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
    
    
    func observeProperty<T>(_ property: ObservableProperty<T>, _ callback: @escaping ObservableProperty<T>.ChangeCallback){
        propertyObserver.observeProperty(property, callback)
    }
    
    func observeDependent<T,R>(_ property1: ObservableProperty<T>, _ property2: ObservableProperty<R>, _ callback: @escaping (T?,R?)->Void){
        propertyObserver.observeDependent(property1, property2, callback: callback)
    }
}
