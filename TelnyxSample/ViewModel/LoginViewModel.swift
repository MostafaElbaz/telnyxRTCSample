import Foundation
import TelnyxRTC

protocol LoginViewModelDelegate: AnyObject {
    func loginSuccess()
    func loginFailed(error: Error)
}

class LoginViewModel {

    weak var delegate: LoginViewModelDelegate?
    private var username: String?
    private var password: String?
    var callManager: CallerManager
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    init(callManager: CallerManager) {
        self.callManager = callManager
    }
    
    func login(username: String?, password: String?) {
        self.username = username
        self.password = password
                
        do {
//            telnyxClient.delegate = self
//            try appDelegate.telnyxClient!.connect(txConfig: txConfig)
            
            callManager.login(username: "MostafaElbaz1", password: "17HdvZVm", completion: { [weak self] status in
                self?.delegate?.loginSuccess()
            })
        } catch let error {
            delegate?.loginFailed(error: error)
        }
    }


}

//extension LoginViewModel: CallerManagerDelegate {
//    func callerManagerDidLoginSuccessfully() {
//        delegate?.loginSuccess()
//    }
//
//
//}
