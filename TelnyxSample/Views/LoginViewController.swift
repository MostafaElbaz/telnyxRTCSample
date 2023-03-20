//
//  LoginViewController.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 16/03/2023.
//
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the view model
        viewModel = LoginViewModel(callManager: CallerManager())
        viewModel.delegate = self
//        usernameTextField.text = "MostafaElbaz1"
//        passwordTextField.text = "17HdvZVm"
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Username or password is empty")
            return
        }
        
        // Call the view model's login function
        viewModel.login(username: username, password: password)
        
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func loginSuccess() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Create a new instance of CallerViewModel with the current Telnyx client
            let callerViewModel = CallerViewModel(callManager: self.viewModel.callManager)
            
            // Create a new instance of CallerViewController with the callerViewModel
            let callerViewController = CallerViewController(viewModel: callerViewModel)
            
            // Create a new window and set the root view controller to CallerViewController
            UIApplication.shared.windows.first?.rootViewController = callerViewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    func loginFailed(error: Error) {
        // Show error message
        print("Login Failed: \(error.localizedDescription)")
    }
}
