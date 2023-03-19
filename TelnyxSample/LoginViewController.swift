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
        viewModel = LoginViewModel()
        viewModel.delegate = self
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
        // Navigate to next screen
        print("Login Successful")
    }
    
    func loginFailed(error: Error) {
        // Show error message
        print("Login Failed: \(error.localizedDescription)")
    }
}
