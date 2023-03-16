//
//  LoginViewModel.swift
//  TelnyxSample
//
//  Created by Mostafa Elbaz on 16/03/2023.
//

import Foundation

class LoginViewModel {
    
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        
        // Check if the username or password fields are empty
        guard !username.isEmpty, !password.isEmpty else {
            completion(false, "Please enter both username and password.")
            return
        }
        
        // Call the login API using the provided username and password
        // Check the response to determine whether the login was successful or not
        // Call the completion block with the result
        
        // Here is an example of calling the completion block with a successful login
        completion(true, nil)
        
        // And here is an example of calling the completion block with a failed login
        // completion(false, "Invalid username or password.")
    }
}
