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
    @IBOutlet weak var loginButton: UIButton!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the ViewModel
        viewModel = LoginViewModel()
        
        // Connect the loginButton to the login function in the ViewModel
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    @objc func loginButtonTapped() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        // Call the login function in the ViewModel and handle the result
        viewModel.login(username: username, password: password) { success, errorMessage in
            if success {
                // Handle successful login
            } else {
                // Handle failed login
                if let errorMessage = errorMessage {
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

