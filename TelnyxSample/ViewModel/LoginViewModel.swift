import Foundation
import TelnyxRTC

protocol LoginViewModelDelegate: AnyObject {
    func loginSuccess()
    func loginFailed(error: String)
}

class LoginViewModel {

    weak var delegate: LoginViewModelDelegate?
    private var username: String?
    private var password: String?
    var callManager: CallerManagerProtocol
    
    init(callManager: CallerManagerProtocol) {
        self.callManager = callManager
    }
    
    func login(username: String, password: String) {
        self.username = username
        self.password = password
                
            callManager.login(username: username, password: password, completion: { [weak self] status in
                if status {
                    self?.delegate?.loginSuccess()
                } else {
                    self?.delegate?.loginFailed(error: "Failed to connect to the server")
                }
            })
    }
}
